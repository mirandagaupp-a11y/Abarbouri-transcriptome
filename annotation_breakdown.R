#annotation breakdown 

library(tidyverse)

# Read in the Trinotate annotation file
trinotate <- read.csv("annotations_subset.csv", head=TRUE)  # Adjust the filename if needed

# Replace blank cells with NA
trinotate[trinotate == "."] <- NA

# Create a named vector for the counts of annotated transcripts per category
annotation_counts <- tibble(
  SwissProt = sum(!is.na(trinotate$sprot_Top_BLASTX_hit) | 
                    !is.na(trinotate$sprot_Top_BLASTP_hit)),
  Infernal = sum(!is.na(trinotate$infernal)),
  Pfam = sum(!is.na(trinotate$Pfam)),
  KEGG = sum(!is.na(trinotate$Kegg)) ,
  GO = sum(!is.na(trinotate$gene_ontology_BLASTX) |
             !is.na(trinotate$gene_ontology_Pfam) |
             !is.na(trinotate$gene_ontology_BLASTP)),
  EggNM = sum(!is.na(trinotate$eggnog) |
                 !is.na(trinotate$EggNM.seed_ortholog) |
                 !is.na(trinotate$EggNM.Description) |
                !is.na(trinotate$EggNM.COG_category) |
                 !is.na(trinotate$EggNM.eggNOG_OGs)),
  SignalP = 35485,
  `Ko Fam` = 43369
)

custom_cols <- c(
  "EggNM"   = "#FF0000",   # bright red
  "GO"       = "#0000FF",   # blue
  "SwissProt"= "#A52A2A",   # dark red
  "Infernal" = "#800080",   # purple
  "PFam"     = "#FFFF00",   # yellow
  "KEGG"     = "#008000",   # green
  "SignalP"  = "#FFA500",   # orange
  "Ko Fam"   = "#0F7F7F"    # teal
)

# Reshape for plotting
annotation_long <- annotation_counts %>%
  pivot_longer(cols = everything(), names_to = "Database", values_to = "AnnotatedTranscripts")

# Plot
ggplot(annotation_long, aes(x = Database, y = AnnotatedTranscripts)) +
  geom_bar(stat = "identity", fill = custom_cols) +
  theme_minimal(base_size = 16) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  labs(y = "Number of unigenes",
    x = NULL
  )

library(ggplot2)

ggplot(annotation_long, aes(x = Database, y = AnnotatedTranscripts)) +
  geom_bar(aes(fill = Database), stat = "identity") +
  scale_fill_manual(values = custom_cols) +
  geom_text(
    aes(label = format(AnnotatedTranscripts, big.mark = ",")),
    vjust = -0.4,
    size = 4,
    color = "black"
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.08))) +
  theme_minimal(base_size = 16) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
    axis.text.y = element_text(color = "black"),
    axis.title = element_text(color = "black"),
    plot.title = element_text(color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black")
  ) +
  labs(
    y = "Number of unigenes",
    x = NULL
  )



