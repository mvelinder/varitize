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
