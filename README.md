# 16s-microbiome-analysis-qiime2-workflow
Automated end-to-end QIIME2 pipeline for 16S rRNA amplicon analysis including DADA2 denoising, SILVA taxonomy classification, phylogenetic tree construction, alpha/beta diversity analysis, genus-level abundance profiling, and TSV/HTML exports.

Here is a **minimal, academic, and professional README.md** version with clean icons and formal structure suitable for GitHub and research repositories.

---

# 🧬 QIIME2 16S rRNA Amplicon Analysis Pipeline

A reproducible, end-to-end QIIME2 workflow for 16S rRNA gene amplicon sequencing analysis, integrating denoising, taxonomic classification, phylogenetic reconstruction, and diversity profiling.

---

## 📖 Overview

This pipeline processes single-end 16S rRNA sequencing data using QIIME2. It enables standardized microbiome analysis from raw FASTQ files to diversity metrics and abundance tables suitable for downstream statistical analysis and publication.

The workflow follows current best practices for ASV-based microbiome analysis.

---

## 🔬 Workflow

1. 📥 **Data Import** (Manifest format)
2. 📊 **Quality Assessment** (Demultiplex summary)
3. 🧪 **DADA2 Denoising** (ASV inference & chimera removal)
4. 📋 **Feature Table Summarization**
5. 🏷️ **Taxonomic Classification** (SILVA 138 classifier)
6. 📈 **Taxonomic Composition Visualization**
7. 🌳 **Phylogenetic Tree Construction** (MAFFT + FastTree)
8. 📐 **Alpha Diversity** (Faith’s Phylogenetic Diversity)
9. 📊 **Core Diversity Metrics** (Phylogenetic alpha & beta diversity)
10. 🧮 **Genus-Level Abundance Profiling**
11. 📂 **TSV Export for Statistical Analysis**
12. 🌐 **Visualization Export (QZV → HTML)**
13. 🌲 **Tree Export (Newick format)**

---

## ⚙️ Requirements

* 🧬 QIIME2 (2023 or newer recommended)
* 📚 SILVA 138 Naive Bayes classifier (.qza)
* 🔢 biom-format
* 🐧 Linux/Unix environment

---

## 📁 Inputs

* `manifest.tsv` — QIIME2-compatible manifest file
* `metadata.tsv` — Sample metadata file
* Pre-trained SILVA classifier

---

## 📊 Outputs

* 🧬 ASV feature table
* 🔎 Representative sequences
* 🏷️ Taxonomy assignments
* 📐 Alpha diversity metrics
* 📊 Beta diversity metrics
* 🧮 Genus-level raw and relative abundance tables
* 🌐 Interactive HTML visualizations
* 🌳 Rooted phylogenetic tree (.nwk)

All outputs are organized in structured directories for reproducibility.

