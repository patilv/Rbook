# Generate cover image for "R and the Tidyverse: A Beginner's Guide"
# Run once: Rscript generate_cover.R

library(ggplot2)
library(grid)

# --- Config ---
gonzaga_red   <- "#a80107"
gonzaga_dark  <- "#6b0004"
accent_blue   <- "#2a5db0"
warm_bg       <- "#faf7f4"
text_dark     <- "#1a1a1a"

width_in  <- 6
height_in <- 9
dpi       <- 300

# --- Build a layered data-art background ---
set.seed(2026)

# Scattered translucent dots (evoke data points)
n_dots <- 220
dots <- data.frame(
  x = runif(n_dots, 0, 10),
  y = runif(n_dots, 0, 15),
  size = runif(n_dots, 0.3, 2.5),
  alpha = runif(n_dots, 0.04, 0.15)
)

# A subtle upward trend line (evokes learning / growth)
trend <- data.frame(
  x = seq(0.5, 9.5, length.out = 80)
)
trend$y <- 2 + 0.8 * trend$x + rnorm(80, 0, 0.6)

# Small bar chart silhouette near bottom
bars <- data.frame(
  x = c(1.5, 3, 4.5, 6, 7.5),
  height = c(2.0, 3.2, 2.8, 4.1, 3.5)
)

# --- Draw ---
p <- ggplot() +

  # Background fill
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf,
           fill = warm_bg) +

  # Large Gonzaga red band across the top third

  annotate("rect", xmin = -0.5, xmax = 10.5, ymin = 9.5, ymax = 15.5,
           fill = gonzaga_red) +

  # Subtle diagonal accent stripe

  annotate("polygon",
           x = c(-0.5, 10.5, 10.5, -0.5),
           y = c(9.0, 10.0, 9.5, 8.5),
           fill = gonzaga_dark, alpha = 0.9) +

  # Scattered dots in the lower area (data-art)
  geom_point(data = dots[dots$y < 9, ],
             aes(x = x, y = y, size = size),
             color = gonzaga_red, alpha = dots$alpha[dots$y < 9],
             show.legend = FALSE) +

  # Trend line
  geom_smooth(data = trend, aes(x = x, y = y),
              method = "loess", se = FALSE,
              color = accent_blue, linewidth = 1.2, alpha = 0.25) +

  # Small bar chart silhouette
  geom_col(data = bars, aes(x = x, y = height),
           fill = gonzaga_red, alpha = 0.12, width = 1.0) +

  # White dots in the red band (decorative)
  geom_point(data = dots[dots$y >= 9.5, ],
             aes(x = x, y = y, size = size * 0.7),
             color = "white", alpha = 0.08,
             show.legend = FALSE) +

  # --- Title text ---
  annotate("text", x = 5, y = 14.0,
           label = "R and the\nTidyverse",
           family = "sans", fontface = "bold",
           size = 14, color = "white", lineheight = 0.85) +

  annotate("text", x = 5, y = 11.5,
           label = "A Beginner's Guide",
           family = "sans", fontface = "italic",
           size = 6.5, color = "#ffcccc") +

  # --- Author ---
  annotate("text", x = 5, y = 0.7,
           label = "Vivek H. Patil",
           family = "sans", fontface = "bold",
           size = 5.5, color = text_dark) +

  # --- Gonzaga tagline ---
  annotate("text", x = 5, y = 10.2,
           label = "GONZAGA UNIVERSITY",
           family = "sans", fontface = "plain",
           size = 3.2, color = "#ffdddd", letterSpacing = 0.15) +

  # --- Scales & theme ---
  scale_size_identity() +
  scale_x_continuous(limits = c(-0.5, 10.5), expand = c(0, 0)) +
  scale_y_continuous(limits = c(-0.5, 15.5), expand = c(0, 0)) +
  theme_void() +
  theme(
    plot.margin = margin(0, 0, 0, 0),
    panel.background = element_rect(fill = warm_bg, color = NA),
    plot.background  = element_rect(fill = warm_bg, color = NA)
  )

ggsave("cover.png", plot = p, width = width_in, height = height_in,
       dpi = dpi, bg = warm_bg)

cat("Cover saved to cover.png (", width_in, "x", height_in, "in @", dpi, "dpi)\n")
