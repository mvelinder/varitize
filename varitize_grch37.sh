VCF=$1
VCF_OUT=$VCF.annot.vcf.gz
TSV_OUT=$VCF_OUT.tsv
REF=~/bin/varitize/resources/Homo_sapiens.GRCh37.dna.toplevel.fa.gz
GFF=~/bin/varitize/resources/Homo_sapiens.GRCh37.87.gff3.gz
LUA=~/bin/varitize/resources/vcfanno_custom.lua
TOML=~/bin/varitize/resources/vcfanno_varitize_grch37.toml

# annotate vcf
bcftools csq -f $REF -g $GFF --phase a --ncsq 20 --threads 16 $VCF \
    | vcfanno -lua $LUA $TOML /dev/stdin \
    | bgzip -c > $VCF_OUT

# convert annotated vcf to tsv
vcf2tsvpy --input_vcf $VCF_OUT --out_tsv $TSV_OUT

# remove first line and remove | from INFO_BCSQ to allow for dataframe searching
tail -n+2 $TSV_OUT | sed 's/|/ /g' > $TSV_OUT.ns.tsv
mv $TSV_OUT.ns.tsv $TSV_OUT

