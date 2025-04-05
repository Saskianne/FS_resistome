#!/usr/bin/perl
use strict;
use warnings;

# Check for correct number of arguments
if (@ARGV != 2) {
    die "Usage: $0 <input_file> <output_file>\n";
}

# Get input and output file paths from command-line arguments
my ($input_file, $output_file) = @ARGV;

# Open the input and output files
open(my $in, '<', $input_file) or die "Cannot open $input_file: $!";
open(my $out, '>', $output_file) or die "Cannot open $output_file: $!";

# Print the updated header for the output file
print $out join("\t", 'Bin', 'GC', 'Genome_size', 'No_contigs', 'Longest_contig', 'N50_contigs', 'Mean_contig_length', 'Coding_density', 'Predicted_genes') . "\n";

# Process each line of the input file
while (my $line = <$in>) {
    # Only process lines that contain .metabat2.bin
    if ($line =~ /^(\S+\.metabat2\.bin\S+)\s+\{(.+)\}$/) {
        my $bin_name = $1;  # Capture the bin name
        my $stats = $2;     # Capture the stats part of the line

        # Extract the required fields using regex
        my ($gc) = $stats =~ /'GC':\s*([\d.]+)/;
        my ($genome_size) = $stats =~ /'Genome size':\s*(\d+)/;
        my ($num_contigs) = $stats =~ /'# contigs':\s*(\d+)/;
        my ($longest_contig) = $stats =~ /'Longest contig':\s*(\d+)/;
        my ($n50_contigs) = $stats =~ /'N50 \(contigs\)':\s*(\d+)/;
        my ($mean_contig_length) = $stats =~ /'Mean contig length':\s*([\d.]+)/;
        my ($coding_density) = $stats =~ /'Coding density':\s*([\d.]+)/;
        my ($predicted_genes) = $stats =~ /'# predicted genes':\s*(\d+)/;

        # Format floating-point values to 3 decimal places
        $gc = sprintf("%.3f", $gc);
        $mean_contig_length = sprintf("%.3f", $mean_contig_length);
        $coding_density = sprintf("%.3f", $coding_density);

        # Print the extracted and formatted information to the output file
        print $out join("\t", $bin_name, $gc, $genome_size, $num_contigs, $longest_contig, $n50_contigs, $mean_contig_length, $coding_density, $predicted_genes) . "\n";
    }
}

# Close the files
close($in);
close($out);

print "Extraction complete! Data saved in $output_file.\n";
