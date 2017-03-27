# Build_SAP_local_reference
Script to build SAP (Statistical Assignment Package) local reference from NR database

# Download NR database
#wget ftp://ftp.ncbi.nih.gov/blast/db/FASTA/nr.gz
#wget ftp://ftp.ncbi.nih.gov/blast/db/FASTA/nr.gz.md5

# Download gb2accession database
#wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/nucl_gb.accession2taxid.gz
#wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid//nucl_gb.accession2taxid.gz.md5

# Download NCBI taxdump
#wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz

# Rename NR database with TaxonID / there is a test file nr.test.fas.gz in the folder if you want to try if the script works
perl add_obitools_extention_accessionID.pl nr.gz nr.rename.fas

# Extract TaxonID
less -S nr.rename.fas | perl -e 'while(<>){if(/taxid=(\d+);/){print "$1\n";} }' | sort | uniq > nr.rename.fas.taxid

# Find TaxonID 
perl find_taxon_through_taxID.pl nr.rename.fas.taxid

# Add TaxonID back to fasta file
perl add_taxon_to_fasta.pl nr.rename.fas nr.rename.fas.taxid.fin nr.rename.taxon.fas
