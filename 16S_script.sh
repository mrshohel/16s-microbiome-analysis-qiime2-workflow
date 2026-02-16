#!/bin/bash
set -euo pipefail

# ==============================
# USER PARAMETERS
# ==============================
THREADS=30
TAX_THREADS=16
TRUNC_LEN=220
SAMPLING_DEPTH=16000

CLASSIFIER="silva-138-99-nb-classifier.qza"
METADATA="/media/lfgp/GEBT/16s/metadata.tsv"
OUTDIR="Final_output"

# ==============================
# CREATE OUTPUT DIRECTORIES
# (DO NOT create 08_core_metrics here)
# ==============================
mkdir -p ${OUTDIR}/{00_import,01_demux,02_dada2,03_table,04_taxonomy,05_barplot,06_tree,07_alpha,09_abundance,10_tsv_exports,11_html,12_tree_nwk}

# ==============================
# STEP 0 — IMPORT
# ==============================
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest.tsv \
  --output-path ${OUTDIR}/00_import/demux.qza \
  --input-format SingleEndFastqManifestPhred33V2

# ==============================
# STEP 1 — DEMUX SUMMARY
# ==============================
qiime demux summarize \
  --i-data ${OUTDIR}/00_import/demux.qza \
  --o-visualization ${OUTDIR}/01_demux/demux.qzv

# ==============================
# STEP 2 — DADA2
# ==============================
qiime dada2 denoise-single \
  --i-demultiplexed-seqs ${OUTDIR}/00_import/demux.qza \
  --p-trim-left 0 \
  --p-trunc-len ${TRUNC_LEN} \
  --p-n-threads ${THREADS} \
  --o-table ${OUTDIR}/02_dada2/table.qza \
  --o-representative-sequences ${OUTDIR}/02_dada2/rep-seqs.qza \
  --o-denoising-stats ${OUTDIR}/02_dada2/denoising-stats.qza

# ==============================
# STEP 3 — FEATURE TABLE SUMMARY
# (NO metadata → avoids QIIME2 bug)
# ==============================
qiime feature-table summarize \
  --i-table ${OUTDIR}/02_dada2/table.qza \
  --o-visualization ${OUTDIR}/03_table/table.qzv

# ==============================
# STEP 4 — TAXONOMY
# ==============================
qiime feature-classifier classify-sklearn \
  --i-classifier ${CLASSIFIER} \
  --i-reads ${OUTDIR}/02_dada2/rep-seqs.qza \
  --o-classification ${OUTDIR}/04_taxonomy/taxonomy.qza \
  --p-n-jobs ${TAX_THREADS}

qiime metadata tabulate \
  --m-input-file ${OUTDIR}/04_taxonomy/taxonomy.qza \
  --o-visualization ${OUTDIR}/04_taxonomy/taxonomy.qzv

# ==============================
# STEP 5 — TAXA BARPLOT
# ==============================
qiime taxa barplot \
  --i-table ${OUTDIR}/02_dada2/table.qza \
  --i-taxonomy ${OUTDIR}/04_taxonomy/taxonomy.qza \
  --m-metadata-file ${METADATA} \
  --o-visualization ${OUTDIR}/05_barplot/taxa-barplot.qzv

# ==============================
# STEP 6 — PHYLOGENETIC TREE
# ==============================
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences ${OUTDIR}/02_dada2/rep-seqs.qza \
  --o-alignment ${OUTDIR}/06_tree/aligned-rep-seqs.qza \
  --o-masked-alignment ${OUTDIR}/06_tree/masked-aligned-rep-seqs.qza \
  --o-tree ${OUTDIR}/06_tree/unrooted-tree.qza \
  --o-rooted-tree ${OUTDIR}/06_tree/rooted-tree.qza

# ==============================
# STEP 7 — ALPHA DIVERSITY
# ==============================
qiime diversity alpha-phylogenetic \
  --i-table ${OUTDIR}/02_dada2/table.qza \
  --i-phylogeny ${OUTDIR}/06_tree/rooted-tree.qza \
  --p-metric faith_pd \
  --o-alpha-diversity ${OUTDIR}/07_alpha/faith_pd.qza

qiime metadata tabulate \
  --m-input-file ${OUTDIR}/07_alpha/faith_pd.qza \
  --o-visualization ${OUTDIR}/07_alpha/faith_pd.qzv

# ==============================
# STEP 8 — CORE METRICS (BETA + ALPHA)
# (QIIME2 CREATES THE DIRECTORY)
# ==============================
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ${OUTDIR}/06_tree/rooted-tree.qza \
  --i-table ${OUTDIR}/02_dada2/table.qza \
  --p-sampling-depth ${SAMPLING_DEPTH} \
  --m-metadata-file ${METADATA} \
  --output-dir ${OUTDIR}/08_core_metrics

# ==============================
# STEP 9 — GENUS-LEVEL ABUNDANCE
# ==============================
qiime taxa collapse \
  --i-table ${OUTDIR}/02_dada2/table.qza \
  --i-taxonomy ${OUTDIR}/04_taxonomy/taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table ${OUTDIR}/09_abundance/genus_counts.qza

qiime feature-table relative-frequency \
  --i-table ${OUTDIR}/09_abundance/genus_counts.qza \
  --o-relative-frequency-table ${OUTDIR}/09_abundance/genus_relative.qza

# ==============================
# STEP 10 — TSV EXPORTS
# ==============================
qiime tools export --input-path ${OUTDIR}/02_dada2/table.qza --output-path ${OUTDIR}/10_tsv_exports/asv
qiime tools export --input-path ${OUTDIR}/09_abundance/genus_counts.qza --output-path ${OUTDIR}/10_tsv_exports/genus_counts
qiime tools export --input-path ${OUTDIR}/09_abundance/genus_relative.qza --output-path ${OUTDIR}/10_tsv_exports/genus_relative
qiime tools export --input-path ${OUTDIR}/04_taxonomy/taxonomy.qza --output-path ${OUTDIR}/10_tsv_exports/taxonomy
qiime tools export --input-path ${OUTDIR}/07_alpha/faith_pd.qza --output-path ${OUTDIR}/10_tsv_exports/alpha

biom convert -i ${OUTDIR}/10_tsv_exports/asv/feature-table.biom -o ${OUTDIR}/10_tsv_exports/asv_raw_counts.tsv --to-tsv
biom convert -i ${OUTDIR}/10_tsv_exports/genus_counts/feature-table.biom -o ${OUTDIR}/10_tsv_exports/genus_raw_counts.tsv --to-tsv
biom convert -i ${OUTDIR}/10_tsv_exports/genus_relative/feature-table.biom -o ${OUTDIR}/10_tsv_exports/genus_relative_abundance.tsv --to-tsv

# ==============================
# STEP 11 — EXPORT ALL QZV → HTML
# ==============================
find ${OUTDIR} -name "*.qzv" | while read qzv; do
  name=$(basename "$qzv" .qzv)
  qiime tools export \
    --input-path "$qzv" \
    --output-path ${OUTDIR}/11_html/"$name"
done

# ==============================
# STEP 12 — TREE → NEWICK
# ==============================
qiime tools export \
  --input-path ${OUTDIR}/06_tree/rooted-tree.qza \
  --output-path ${OUTDIR}/12_tree_nwk

echo "===================================================="
echo "PIPELINE COMPLETED SUCCESSFULLY"
echo "HTML: ${OUTDIR}/11_html/*/index.html"
echo "TREE: ${OUTDIR}/12_tree_nwk/tree.nwk"
echo "===================================================="

