import re
import argparse

def extract_genes(input_file, output_file, regex_pattern):
    # Compile the regular expression
    pattern = re.compile(regex_pattern)
    
    # Read the FASTA file and extract matching sequences
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        write_sequence = False
        sequence_lines = []
        
        for line in infile:
            if line.startswith(">"):  # Header line
                if write_sequence and sequence_lines:
                    outfile.write("".join(sequence_lines))
                sequence_lines = []  # Reset sequence buffer
                write_sequence = bool(pattern.search(line))  # Check if header matches regex
                if write_sequence:
                    outfile.write(line)  # Write header to output
            elif write_sequence:  # Sequence line
                sequence_lines.append(line)
        
        # Write the last sequence if applicable
        if write_sequence and sequence_lines:
            outfile.write("".join(sequence_lines))

if __name__ == "__main__":
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Extract specific sequences from a FASTA file based on header regex.")
    parser.add_argument("-i", "--input", required=True, help="Input FASTA file")
    parser.add_argument("-o", "--output", required=True, help="Output FASTA file")
    parser.add_argument("-r", "--regex", default="partial=00", help="Regex pattern to filter headers (default: 'partial=00')")
    
    args = parser.parse_args()
    
    # Run the extraction function
    extract_genes(args.input, args.output, args.regex)
