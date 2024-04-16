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
