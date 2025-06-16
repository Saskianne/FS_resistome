#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

# Inputs
my $input_file = $ARGV[0] or die "Please provide input file (e.g., reads.fastq)\n";
my $min_length = $ARGV[1] or die "Please provide minimum sequence length (e.g., 300)\n";
my $file_prefix = $ARGV[2] // "";  # Optional

# Parse filename
my ($fileBaseName, $dirName, $fileExtension) = fileparse($input_file, qr/\.(fa|fasta|fastq|fna|faa)$/);
my $output_file = $file_prefix . $fileBaseName . "_min" . $min_length . $fileExtension;

# Open files
open(my $IN, "<", $input_file) or die "Can't open input file '$input_file'\n";
open(my $OUT, ">", $output_file) or die "Can't write to output file '$output_file'\n";

# Process FASTQ in 4-line blocks
while (my $header = <$IN>) {
    my $seq = <$IN>;
    my $plus = <$IN>;
    my $qual = <$IN>;

    chomp($header, $seq, $plus, $qual);

    if (length($seq) >= $min_length) {
        print $OUT "$header\n$seq\n$plus\n$qual\n";
    }
}

close($IN);
close($OUT);
