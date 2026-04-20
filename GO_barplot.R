# Top10_GO_barplot_faceted.R
# Makes a 3-panel (MF / BP / CC) GO barplot like your example image,
# using ONLY the top 10 terms per GO category.

library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats)
library(readr)
install.packages("ggtext")   # if not installed
library(ggtext)

# -----------------------------
# 1) Read GO annotation file
# -----------------------------
# In RStudio, set this to your local path (or use file.choose())
# df <- read.delim("go_edit.txt", sep = "\t", header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)

df <- read.delim("go_edit.txt", sep = "\t", header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)

# -----------------------------
# 2) Long-format GO terms
# -----------------------------
# Assumes GO annotations are in gene_ontology_BLASTX with entries separated by ` and fields separated by ^
# Example entry: GO:0003677^molecular_function^DNA binding
go_long <- df %>%
  select(X.gene_id, gene_ontology_BLASTX) %>%
  filter(!is.na(gene_ontology_BLASTX), gene_ontology_BLASTX != "") %>%
  separate_rows(gene_ontology_BLASTX, sep = "`") %>%
  separate(gene_ontology_BLASTX,
           into = c("GO_ID", "Category", "Term"),
           sep = "\\^",
           fill = "right",
           extra = "merge") %>%
  filter(!is.na(Category), !is.na(Term), Category != "", Term != "")

# -----------------------------
# 3) Count genes per term
# -----------------------------
go_counts <- go_long %>%
  distinct(X.gene_id, Category, Term) %>%
  count(Category, Term, name = "Number_of_genes")

# -----------------------------
# 4) Keep Top 10 terms per category
# -----------------------------
category_levels <- c("molecular_function", "biological_process", "cellular_component")

top_terms <- go_counts %>%
  filter(Category %in% category_levels) %>%
  group_by(Category) %>%
  slice_max(order_by = Number_of_genes, n = 10, with_ties = FALSE) %>%
  ungroup() %>%
  mutate(
    Category = factor(Category, levels = category_levels),
    Term = fct_reorder(Term, Number_of_genes, .desc = TRUE)
  )

# -----------------------------
# 5) Colors + colored facet titles (no ggtext needed)
# -----------------------------
cat_cols <- c(
  molecular_function = "#F8766D",  # salmon
  biological_process = "#00BA38",  # green
  cellular_component = "#619CFF"   # blue
)

# We'll remove the facet strips and add our own colored titles inside each facet.
title_df <- data.frame(
  Category = factor(category_levels, levels = category_levels),
  x = -Inf,
  y = Inf,
  label = c("Molecular Function", "Biological Process", "Cellular Component"),
  col = unname(cat_cols[category_levels])
)

# -----------------------------
# 6) Plot
# -----------------------------
p <- ggplot(top_terms, aes(x = Term, y = Number_of_genes, fill = Category)) +
  geom_col(width = 0.9) +
  facet_wrap(~Category, scales = "free_x", nrow = 1) +
  scale_fill_manual(values = cat_cols, guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.08))) +
  labs(x = "GO Term",
    y = "Number of Annotated Genes"
  ) +
  # Remove facet strip labels so we don't get double titles
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line.x = element_line(color = "black"),
    axis.line.y = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    axis.text.x = element_text(angle = -60, hjust = 0, vjust = 1, size = 12, color = "black"),
    axis.text.y = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 12, color = "black"),
    strip.text = element_blank(),
    strip.background = element_blank(),
    plot.title = element_text(size = 18, face = "bold", hjust = 0)
  ) +
  # Add colored titles inside each facet
  geom_text(
    data = title_df,
    aes(x = x, y = y, label = label, color = col),
    inherit.aes = FALSE,
    hjust = -0.02, vjust = 1.1,
    fontface = "bold",
    size = 6
  ) +
  scale_color_identity()

p
