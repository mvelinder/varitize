VCF=$1
VCF_OUT=$VCF.annot.vcf.gz
TSV_OUT=$VCF_OUT.tsv
REF=~/bin/varitize/resources/Homo_sapiens.GRCh38.dna.toplevel.chr.fa.gz
GFF=~/bin/varitize/resources/Homo_sapiens.GRCh38.111.chr.gff3.fix.gz
LUA=~/bin/varitize/resources/vcfanno_custom.lua
TOML=~/bin/varitize/resources/vcfanno_varitize.toml

# annotate vcf
bcftools csq -f $REF -g $GFF --phase a --ncsq 20 --threads 16 $VCF \
    | vcfanno -lua $LUA $TOML /dev/stdin \
    | bgzip -c > $VCF_OUT

# convert annotated vcf to tsv
vcf2tsvpy --input_vcf $VCF_OUT --out_tsv $TSV_OUT

# remove first line and remove | from INFO_BCSQ to allow for dataframe searching
tail -n+2 $TSV_OUT | sed 's/|/ /g' > $TSV_OUT.ns.tsv
mv $TSV_OUT.ns.tsv $TSV_OUT
