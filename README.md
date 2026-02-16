# 16s-microbiome-analysis-qiime2-workflow
Automated end-to-end QIIME2 pipeline for 16S rRNA amplicon analysis including DADA2 denoising, SILVA taxonomy classification, phylogenetic tree construction, alpha/beta diversity analysis, genus-level abundance profiling, and TSV/HTML exports.

QIIME2 16S rRNA Amplicon Analysis Pipeline

A reproducible end-to-end QIIME2 workflow for 16S rRNA gene amplicon sequencing data analysis, including denoising, taxonomic classification, phylogenetic reconstruction, and diversity analysis.

Overview

This pipeline processes single-end 16S rRNA amplicon sequencing data using QIIME2. It performs quality control, ASV inference, taxonomy assignment with SILVA 138, phylogenetic tree construction, alpha and beta diversity analysis, and export of abundance tables for downstream statistical analysis.

Workflow Summary

Import sequencing data (manifest format)

Quality assessment (demux summary)

DADA2 denoising and ASV generation

Feature table summarization

Taxonomic classification (SILVA 138)

Taxonomic composition visualization

Phylogenetic tree construction (MAFFT + FastTree)

Alpha diversity (Faith’s PD)

Core diversity metrics (phylogenetic alpha and beta diversity)

Genus-level abundance profiling

Export of feature tables (TSV format)

Export of visualizations (HTML)

Export of rooted tree (Newick format)

Requirements

QIIME2 (2023+ recommended)

SILVA 138 Naive Bayes classifier (.qza)

biom-format

Linux/Unix environment

Inputs

manifest.tsv (QIIME2-compatible manifest file)

metadata.tsv (sample metadata file)

Pre-trained SILVA classifier

Outputs

ASV feature table

Representative sequences

Taxonomy assignments

Alpha and beta diversity metrics

Genus-level abundance tables (raw and relative)

HTML visualizations

Rooted phylogenetic tree (Newick format)
