library(dplyr)
library(ggplot2)
library(readr)
library(patchwork)

# -------------------------
# 1) Read summary
# -------------------------
kegg_summary <- read_csv("kegg_barplot_summary.csv", show_col_types = FALSE)

required_cols <- c("Category", "Subcategory", "Gene_Count", "Percent")
missing_cols <- setdiff(required_cols, names(kegg_summary))
if (length(missing_cols) > 0) {
  stop("kegg_barplot_summary.csv is missing columns: ",
       paste(missing_cols, collapse = ", "))
}

# -------------------------
# 2) Set category order + colors (matches KEGG-style palettes)
# -------------------------
category_levels <- c(
  "Cellular Processes",
  "Environmental Information Processing",
  "Genetic Information Processing",
  "Metabolism",
  "Organismal Systems",
  "Human Diseases"
)

cat_cols <- c(
  "Cellular Processes" = "#FFD700",                    # yellow
  "Environmental Information Processing" = "#00C853",  # green
  "Genetic Information Processing" = "#00B0FF",        # blue
  "Metabolism" = "#9C27B0",                            # purple
  "Organismal Systems" = "#E91E63",                    # pink
  "Human Diseases" = "#FFA500"                         # orange
)

# Keep only expected categories (prevents accidental NA fills)
kegg_summary <- kegg_summary %>%
  filter(Category %in% category_levels) %>%
  mutate(Category = factor(Category, levels = category_levels))

# -------------------------
# 3) Order subcategories (grouped by Category)
#    Choose ONE of the two styles below:
#    A) Within each category: largest -> smallest (common)
#    B) Within each category: smallest -> largest
# -------------------------

# A) Largest -> smallest within each category
kegg_summary <- kegg_summary %>%
  group_by(Category) %>%
  arrange(desc(Gene_Count), .by_group = TRUE) %>%
  ungroup()

# If you prefer B) Smallest -> largest, replace the block above with:
# kegg_summary <- kegg_summary %>%
#   group_by(Category) %>%
#   arrange(Gene_Count, .by_group = TRUE) %>%
#   ungroup()

# Final y-axis order is the row order at this point:
kegg_summary <- kegg_summary %>%
  mutate(Subcategory = factor(Subcategory, levels = unique(Subcategory)))

subcat_levels <- levels(kegg_summary$Subcategory)

# -------------------------
# 4) Build RIGHT STRIP data in the SAME coordinate system
#    We compute numeric ymin/ymax in "discrete slots":
#    - discrete slot centers are 1,2,3,...,N
#    - boundaries between bars are at .5 increments
# -------------------------
strip_df <- kegg_summary %>%
  count(Category, name = "n_subcats") %>%
  mutate(Category = factor(as.character(Category), levels = category_levels)) %>%
  arrange(Category) %>%
  mutate(
    ymin = lag(cumsum(n_subcats), default = 0) + 0.5,
    ymax = cumsum(n_subcats) + 0.5,
    ymid_index = (ymin + ymax) / 2
  ) %>%
  mutate(
    # choose a valid subcategory level near the middle to position the label on the discrete y scale
    ymid_label = subcat_levels[pmin(pmax(round(ymid_index), 1), length(subcat_levels))]
  )

# -------------------------
# 5) Main barplot
# -------------------------
p_main <- ggplot(kegg_summary, aes(x = Percent, y = Subcategory, fill = Category)) +
  geom_col(width = 0.85) +
  geom_text(
    aes(label = format(Gene_Count, big.mark = ",")),
    hjust = -0.08,
    size = 4.2,
    color = "black"
  ) +
  scale_fill_manual(values = cat_cols, guide = "none") +
  # lock y scale so both plots align perfectly
  scale_y_discrete(limits = subcat_levels) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(x = "Percent of Annotated Genes (%)", y = NULL) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.y = element_text(color = "black", size = 11),
    axis.text.x = element_text(color = "black", size = 11),
    axis.title.x = element_text(color = "black", size = 11),
    axis.line = element_line(color = "black")
  )

# -------------------------
# 6) Right-side category strip (ALIGNED)
#    - we draw rectangles using ymin/ymax boundaries
#    - we enforce SAME y discrete limits
# -------------------------
strip_df <- strip_df %>%
  mutate(Category_label = recode(Category,
                                 "Cellular Processes" = "Cellular Processes",
                                 "Environmental Information Processing" = "Environmental Information\nProcessing",
                                 "Genetic Information Processing" = "Genetic Information\nProcessing",
                                 "Metabolism" = "Metabolism",
                                 "Organismal Systems" = "Organismal Systems",
                                 "Human Diseases" = "Human Diseases"
  ))

p_strip <- ggplot() +
  geom_rect(
    data = strip_df,
    aes(xmin = 0.35, xmax = 0.65, ymin = ymin, ymax = ymax, fill = Category),
    inherit.aes = FALSE
  ) +
  geom_text(
    data = strip_df,
    aes(
      x = 0.68,
      y = ymid_label,
      label = Category_label
    ),
    inherit.aes = FALSE,
    hjust = 0,
    size = 4.2,
    color = "black"
  ) +
  scale_fill_manual(values = cat_cols, guide = "none") +
  # CRITICAL: same y scale limits as p_main
  scale_y_discrete(limits = subcat_levels) +
  coord_cartesian(clip = "off") +
  theme_void(base_size = 12) +
  theme(
    plot.margin = margin(t = 5, r = 165, b = 5, l = 5)
  )

# -------------------------
# 7) Combine (make strip thin)
# -------------------------
p_final <- p_main + p_strip + plot_layout(widths = c(20, 0.2))
p_final
