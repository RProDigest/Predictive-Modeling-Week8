# Demonstration: K-means vs Gaussian Mixture Models
# Same cluster centers, different assignments

# Load packages
library(mclust)
library(tidyverse)
library(patchwork)

set.seed(123)

# Okabe-Ito colorblind-friendly palette
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2")

# Helper function to create clusters
create_cluster <- function(n, mean_x, mean_y, sd) {
  tibble(X1 = rnorm(n, mean_x, sd), X2 = rnorm(n, mean_y, sd))
}

# Generate data
data_tibble <- bind_rows(
  create_cluster(150, 0, 0, 2.5),    # Large, diffuse cluster
  create_cluster(20, 5, 2, 0.5),     # Small clusters
  create_cluster(20, 3, 5, 0.5),
  create_cluster(20, -4, 3, 0.5),
  create_cluster(20, -3, -4, 0.5)
)

data_matrix <- as.matrix(data_tibble)

# Run clustering algorithms
kmeans_fit <- kmeans(data_matrix, centers = 5, nstart = 25)
gmm_fit <- me(modelName = "VVV", data = data_matrix, 
              z = unmap(kmeans_fit$cluster))

# Extract results
results <- tibble(
  idx = seq_len(nrow(data_matrix)),
  kmeans_cluster = kmeans_fit$cluster,
  gmm_cluster = apply(gmm_fit$z, 1, which.max)
) %>%
  bind_cols(data_tibble)

# Find 3 example points in different k-means but same GMM cluster
example_idx <- results %>%
  group_by(gmm_cluster) %>%
  filter(n_distinct(kmeans_cluster) >= 3) %>%
  slice(1) %>%
  pull(gmm_cluster) %>%
  first()

example_points <- results %>%
  filter(gmm_cluster == example_idx) %>%
  group_by(kmeans_cluster) %>%
  slice(1) %>%
  ungroup() %>%
  slice(1:3) %>%
  pull(idx)

# Print results
cat("═══════════════════════════════════════\n")
cat("  K-MEANS vs GMM DEMONSTRATION\n")
cat("═══════════════════════════════════════\n\n")

cat("THREE EXAMPLE POINTS:\n")
cat("─────────────────────────────────────\n")
results %>%
  filter(idx %in% example_points) %>%
  mutate(Point = row_number()) %>%
  select(Point, X1, X2, kmeans_cluster, gmm_cluster) %>%
  pwalk(~{
    cat(sprintf("\nPoint %d: (%.2f, %.2f)\n", ..1, ..2, ..3))
    cat(sprintf("  K-means → Cluster %d\n", ..4))
    cat(sprintf("  GMM     → Cluster %d\n", ..5))
  })

cat("\n✓ Different clusters in K-means\n")
cat("✓ Same cluster in GMM\n\n")

cat("GMM POSTERIOR PROBABILITIES:\n")
cat("─────────────────────────────────────\n")
walk(example_points, ~{
  probs <- gmm_fit$z[.x, ]
  cat(sprintf("\nPoint %d:\n", which(example_points == .x)))
  imap(probs, ~cat(sprintf("  Cluster %d: %.3f%s\n", 
                           .y, .x, if(.x == max(probs)) " ← assigned" else "")))
})

# Prepare plot data
plot_df <- results %>%
  mutate(
    is_example = idx %in% example_points,
    KMeans = factor(kmeans_cluster),
    GMM = factor(gmm_cluster)
  )

centers_km <- as_tibble(kmeans_fit$centers) %>% set_names(c("X1", "X2"))
centers_gmm <- as_tibble(t(gmm_fit$parameters$mean)) %>% set_names(c("X1", "X2"))

# Custom theme
theme_cluster <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0),
    plot.subtitle = element_text(size = 11, color = "grey30", hjust = 0),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey90", linewidth = 0.3),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 10),
    axis.title = element_text(face = "bold")
  )

# Helper function for plots
create_plot <- function(data, color_var, centers, title, subtitle) {
  ggplot(data, aes(x = X1, y = X2)) +
    geom_point(aes(color = {{color_var}}, alpha = is_example, 
                   size = is_example, shape = is_example)) +
    geom_point(data = centers, shape = 8, size = 6, 
               color = "black", stroke = 1.5) +
    scale_color_manual(values = okabe_ito, name = "Cluster") +
    scale_alpha_manual(values = c(0.5, 1), guide = "none") +
    scale_size_manual(values = c(2, 4), guide = "none") +
    scale_shape_manual(values = c(16, 17), 
                       labels = c("Other points", "Example points"),
                       name = "") +
    labs(title = title, subtitle = subtitle, 
         x = "Feature 1", y = "Feature 2") +
    theme_cluster
}

# Create plots
p1 <- create_plot(plot_df, KMeans, centers_km,
                  "K-means Clustering",
                  "Hard assignment: each point to nearest center")

p2 <- create_plot(plot_df, GMM, centers_gmm,
                  "Gaussian Mixture Model",
                  "Soft assignment: considers distance, covariance, and mixing weights")

# Display
final_plot <- (p1 | p2) +
  plot_annotation(
    title = "Same Centers, Different Assignments",
    subtitle = "Triangular points assigned to different k-means clusters but same GMM cluster",
    caption = "Plotted by M.Nsofu, Oct 2025",
    theme = theme(
      plot.title = element_text(face = "bold", size = 16),
      plot.subtitle = element_text(size = 12, color = "grey40"),
      plot.caption = element_text(size = 10, hjust = 1, color = "grey50")
    )
  )

# Display the plot
print(final_plot)

# Save high-resolution plot
ggsave(
  filename = "kmeans_vs_gmm_comparison.png",
  plot = final_plot,
  width = 14,
  height = 7,
  dpi = 600,
  bg = "white"
)

cat("\n═══════════════════════════════════════\n")
cat("✓ Plot saved as 'kmeans_vs_gmm_comparison.png'\n")
cat("  (High resolution: 300 DPI)\n")
cat("═══════════════════════════════════════\n")