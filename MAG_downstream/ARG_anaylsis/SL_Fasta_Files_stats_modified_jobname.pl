#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

# Get input arguments
my $folder = $ARGV[0] or die "Usage: $0 <folder> [cutoff_length] [jobname]\n";
my $cutoff_length = $ARGV[1] // 0;
# Use SLURM_JOB_NAME if available, otherwise fallback to 'fasta_statistics'
my $jobname = $ENV{'SLURM_JOB_NAME'} // 'fasta_statistics';

# Print out the folder and cutoff length
print "Folder: $folder\nCutoff: $cutoff_length\n";

# Open the directory and read the list of files
opendir my $dir, $folder or die "Could not open folder '$folder': $!\n";
my @files = readdir($dir);
closedir $dir;

# Open the output file for writing statistics
open my $out, '>', "$folder/${jobname}.xls" or die "Could not write to output file: $!\n";
print $out "File Name\tNo:Contigs\tTotal Length\tMinimum Length\tAVG Length\tMax Length\tGC %\tN50 Contigs\tN50 bp\n";

# Iterate through each file in the folder
foreach my $file (sort @files) {
    next if $file =~ /^\./;  # Skip hidden files or current/parent directory references
    next if $file =~ /_Statistics\.xls$/;  # Skip statistics files

    my $file_path = "$folder/$file";
    process_file($file_path, $cutoff_length, $out);
}

close $out;
print "Statistics written to $folder/${jobname}.xls\n";

# Subroutine to process each file and calculate stats
sub process_file {
    my ($file, $cutoff_length, $out) = @_;

    open my $fh, '<', $file or die "Could not open file '$file': $!\n";

    my ($total_contigs, $total_length, $gc_count) = (0, 0, 0);
    my ($min_length, $max_length) = (0, 0);
    my (%lengths, $sequence, $seq_id);

    while (<$fh>) {
        chomp;

        # Detect a new sequence header
        if (/^>(.*)/) {
            process_sequence(\$sequence, \$total_contigs, \$total_length, \$gc_count, \$min_length, \$max_length, \%lengths, $cutoff_length) if $sequence;

            # Start a new sequence
            $seq_id = $1;
            $sequence = '';
        } else {
            $sequence .= $_;
        }
    }

    # Process the last sequence in the file
    process_sequence(\$sequence, \$total_contigs, \$total_length, \$gc_count, \$min_length, \$max_length, \%lengths, $cutoff_length) if $sequence;

    close $fh;

    # Calculate N50
    my ($n50_contigs, $n50_length) = calculate_n50(\%lengths, $total_length);

    # Calculate GC percentage and average length
    my $gc_percentage = $total_length > 0 ? sprintf("%.3f", ($gc_count / $total_length) * 100) : 0;
    my $avg_length = $total_contigs > 0 ? sprintf("%.3f", $total_length / $total_contigs) : 0;

    # Print the statistics to the output file
    print $out join("\t", basename($file), $total_contigs, $total_length, $min_length, $avg_length, $max_length, $gc_percentage, $n50_contigs, $n50_length), "\n";
}

# Subroutine to process a sequence and update statistics
sub process_sequence {
    my ($sequence_ref, $total_contigs_ref, $total_length_ref, $gc_count_ref, $min_length_ref, $max_length_ref, $lengths_ref, $cutoff_length) = @_;

    my $seq_len = length $$sequence_ref;
    return if $seq_len < $cutoff_length;

    $$total_length_ref += $seq_len;
    $$total_contigs_ref++;

    # Update GC count
    my $gc = ($$sequence_ref =~ tr/GCgc//);
    $$gc_count_ref += $gc;

    # Update min and max lengths
    $$min_length_ref = $seq_len if $$min_length_ref == 0 || $seq_len < $$min_length_ref;
    $$max_length_ref = $seq_len if $seq_len > $$max_length_ref;

    # Store sequence length for N50 calculation
    $lengths_ref->{$$total_contigs_ref} = $seq_len;

    # Reset the sequence reference
    $$sequence_ref = '';
}

# Subroutine to calculate N50
sub calculate_n50 {
    my ($lengths_ref, $total_length) = @_;
    my ($n50_contigs, $n50_length) = (0, 0);
    my $half_length = $total_length / 2;

    foreach my $contig_id (sort { $lengths_ref->{$b} <=> $lengths_ref->{$a} } keys %$lengths_ref) {
        $n50_length += $lengths_ref->{$contig_id};
        $n50_contigs++;

        # Stop once we reach half of the total length
        last if $n50_length >= $half_length;
    }

    return ($n50_contigs, $n50_length);
}
