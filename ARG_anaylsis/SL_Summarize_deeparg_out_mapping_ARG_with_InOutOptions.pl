#!/usr/bin/perl
use strict;
use warnings;

# Check for command-line arguments (input and output files)
if (@ARGV != 2) {
    die "Usage: $0 <input_file> <output_file>\n";
}

my ($input_file, $output_file) = @ARGV;

# Open the input file
open my $fh, '<', $input_file or die "Cannot open input file '$input_file': $!";

# Automatically detect delimiter from the first row (comma or tab)
my $first_line = <$fh>;
chomp($first_line);
my $delimiter;
if ($first_line =~ /,/) {
    $delimiter = ',';   # Comma-separated
} elsif ($first_line =~ /\t/) {
    $delimiter = "\t";  # Tab-separated
} else {
    die "Unable to determine delimiter. File must be either comma-separated or tab-separated.\n";
}

# Go back to the start of the file after determining delimiter
seek $fh, 0, 0;

# Initialize a hash to store counts of ARG classes
my %count;
my $total = 0;

# Read the file line by line
while (<$fh>) {
    chomp;
    next if $. == 1;  # Skip the header row
    my @fields = split /$delimiter/;  # Split fields by detected delimiter

    # Make sure the 5th column exists and is not empty
    if (defined $fields[4] && $fields[4] ne '') {
        my $arg_class = $fields[4];
        $count{$arg_class}++;
        $total++;
    }
}

close $fh;

# Open the output file to save results
open my $out, '>', $output_file or die "Cannot open output file '$output_file': $!";

# Print the counts and calculate percentage
foreach my $arg_class (sort keys %count) {
    my $percentage = ($count{$arg_class} / $total) * 100;
    printf $out "%d %s %.2f%%\n", $count{$arg_class}, $arg_class, $percentage;
}

close $out;

print "Summary saved to $output_file\n";
