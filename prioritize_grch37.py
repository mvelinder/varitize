import sys
import os
import pandas as pd

tsvin = sys.argv[1]
genelist = sys.argv[2]

# import all variants into dataframe
vts = pd.read_csv(tsvin, sep='\t', low_memory=False)

# write impactful variants to a new file
vts[~vts['INFO_BCSQ'].str.contains("intron|prime_utr|non_coding|\.")].to_csv(tsvin + '.impactful.tsv', sep='\t', index=False)

# make new dataframe for impactful variants

ivts = vts[~vts['INFO_BCSQ'].str.contains("intron|prime_utr|non_coding|\.")] 

# write impactful variants that are not clinvar (likely) benign to a new file

ivts[~ivts['ClinVar_Significance'].str.contains('Benign|Likely_benign') & ~ivts['ClinVar_Confidence'].str.contains('Benign|Likely_benign')].to_csv(tsvin + '.impactful.not.benign.tsv', sep='\t', index=False)

# make new dataframe for impactful, not (likely) benign variants

nbivts = ivts[~ivts['ClinVar_Significance'].str.contains('Benign|Likely_benign') & ~ivts['ClinVar_Confidence'].str.contains('Benign|Likely_benign')]

# write impactful variants that are clinvar (likely) pathogenic to a new file

ivts[ivts['ClinVar_Significance'].str.contains('Pathogenic|Likely_pathogenic') | ivts['ClinVar_Confidence'].str.contains('Pathogenic|Likely_pathogenic')].to_csv(tsvin + '.impactful.likely.pathogenic.tsv', sep='\t', index=False)

# make new dataframe for impactful, not (likely) pathogenic variants

lpivts = ivts[ivts['ClinVar_Significance'].str.contains('Pathogenic') | ivts['ClinVar_Confidence'].str.contains('Pathogenic|Likely_pathogenic')]

# write predicted deleterious missense variants to a new file

vts[(vts['INFO_BCSQ'].str.contains('missense')) & ((vts['AlphaMissense'] >= '0.6') | (vts['REVEL'] >= '0.6') | (vts['MutScore'] >= '0.6'))].to_csv(tsvin + '.missense.deleterious.tsv', sep='\t', index=False)

mvts = vts[(vts['INFO_BCSQ'].str.contains('missense')) & ((vts['AlphaMissense'] >= '0.6') | (vts['REVEL'] >= '0.6') | (vts['MutScore'] >= '0.6'))]

# find genes of interest from list in impactful variants dataframe
# open gene list file
with open(genelist) as f:
    genes = [line.rstrip('\n') for line in f]

# write intersection to new file
ivts[ivts['INFO_BCSQ'].str.contains(' | '.join(genes))].to_csv(tsvin + '.' + genelist + '.impactful.tsv', sep='\t', index=False)
