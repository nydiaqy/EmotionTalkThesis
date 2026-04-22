full <- read_rds(here("01Data", "02Derived", "CRQA full data.rds"))

# ==============================================================
# Three-Panel CRQA Figure for Thesis
# Panel A: Binary emotion event sequences (Instructor & Child)
# Panel B: Turn-level Cross-Recurrence Plot (CRP)
# Panel C: Lagged Recurrence Rate (RR%) Profile
# ==============================================================

# ---- 0. Packages ----
# install.packages("ggplot2")  # uncomment if needed
library(ggplot2)

# ---- 1. EDIT YOUR DATA HERE ----
# Binary sequences: 1 = emotion word present, 0 = absent
# 20 turns each, aligned turn-by-turn (instructor turn 1 ↔ child turn 1, etc.)

# These sequences produce peak RR near lag 0 (co-occurrence within ±2 turns)
# The two speakers echo each other closely, with a slight offset
instructor <- c(0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0)
child      <- c(0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0)

N <- length(instructor)   # should be 20
W <- 4                     # window half-width (max lag); adjust as needed

# ---- 2. Build data frames ----

# --- Panel A: binary event sequences ---
df_events <- data.frame(
  time   = rep(1:N, 2),
  person = rep(c("Child", "Instructor"), each = N),
  event  = c(child, instructor)
)

# --- Panel B: cross-recurrence matrix ---
# CRP: cell (i,j) = 1 if instructor[i] == 1 AND child[j] == 1
crp_mat <- outer(instructor, child, FUN = function(a, b) as.integer(a == 1 & b == 1))

# Keep only cells within the diagonal band |i - j| <= W
df_crp <- expand.grid(instructor_turn = 1:N, child_turn = 1:N)
df_crp$recur <- as.vector(crp_mat)
df_crp$in_band <- abs(df_crp$instructor_turn - df_crp$child_turn) <= W
df_crp$show <- df_crp$recur == 1  # points to plot

# --- Panel C: lagged recurrence rate profile ---
lags <- (-W):W
rr_vals <- sapply(lags, function(L) {
  if (L >= 0) {
    n_pairs <- N - L
    if (n_pairs <= 0) return(NA)
    co <- sum(instructor[1:n_pairs] == 1 & child[(L + 1):N] == 1)
  } else {
    n_pairs <- N + L
    if (n_pairs <= 0) return(NA)
    co <- sum(instructor[(-L + 1):N] == 1 & child[1:n_pairs] == 1)
  }
  return(co / n_pairs * 100)   # RR as percentage
})

df_profile <- data.frame(lag = lags, RR = rr_vals)


# ---- 3. Plot Panel A: Binary event sequences ----
panel_A <- ggplot(df_events, aes(x = time, y = person)) +
  geom_point(
    data = subset(df_events, event == 1),
    shape = 15, size = 3
  ) +
  scale_x_continuous(
    breaks = seq(0, N, by = 5),
    limits = c(0.5, N + 0.5),
    expand = c(0, 0)
  ) +
  scale_y_discrete(limits = c("Child", "Instructor")) +
  labs(x = "Turn", y = "Use of Emotion Words") +
  theme_classic(base_size = 12) +
  theme(
    axis.title.y = element_text(angle = 90),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
    plot.margin  = margin(5, 10, 5, 5)
  )
panel_A

# ---- 4. Plot Panel B: Cross-Recurrence Plot ----
panel_B <- ggplot() +
  # Recurrence points
  geom_point(
    data = subset(df_crp, show),
    aes(x = child_turn, y = instructor_turn),
    shape = 15, size = 2
  ) +
  # Main diagonal (solid)
  geom_abline(intercept = 0, slope = 1, colour = "grey40", linewidth = 0.6) +
  # Band boundaries (dashed)
  geom_abline(intercept =  W, slope = 1, colour = "grey40", linewidth = 0.4, linetype = "dashed") +
  geom_abline(intercept = -W, slope = 1, colour = "grey40", linewidth = 0.4, linetype = "dashed") +
  scale_x_continuous(
    breaks = seq(0, N, by = 5),
    limits = c(0, N + 0.5),
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    breaks = seq(0, N, by = 5),
    limits = c(0, N + 0.5),
    expand = c(0, 0)
  ) +
  labs(x = "Child (turn)", y = "Instructor (turn)") +
  coord_equal() +
  theme_classic(base_size = 12) +
  theme(
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
    plot.margin  = margin(5, 10, 5, 5)
  )
panel_B

# ---- 5. Plot Panel C: Lagged RR profile ----
panel_C <- ggplot(df_profile, aes(x = lag, y = RR)) +
  geom_line(linewidth = 0.6) +
  geom_point(shape = 21, fill = "white", size = 2.5, stroke = 0.7) +
  # Vertical reference lines
  geom_vline(xintercept = 0,  linewidth = 0.6) +
  geom_vline(xintercept = -W, linetype = "dashed", linewidth = 0.4) +
  geom_vline(xintercept =  W, linetype = "dashed", linewidth = 0.4) +
  # Direction labels below the axis
  annotate("text", x = -W/2, y = -Inf, label = "\u2190 Partner leading",
           size = 3, vjust = 4, hjust = 0.5) +
  annotate("text", x =  W/2, y = -Inf, label = "Child leading \u2192",
           size = 3, vjust = 4, hjust = 0.5) +
  scale_x_continuous(breaks = (-W):W) +
  scale_y_continuous(
    limits = c(0, NA),
    expand = expansion(mult = c(0, 0.05))
  ) +
  labs(x = "Lag", y = "RR (%)") +
  coord_cartesian(clip = "off") +
  theme_classic(base_size = 12) +
  theme(
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
    plot.margin  = margin(5, 10, 25, 5)   # extra bottom margin for direction labels
  )
panel_C

# ---- 6. Combine into a 3-panel figure ----
# Option A: use patchwork (recommended)
# install.packages("patchwork")  # uncomment if needed
library(patchwork)

fig <- panel_A + panel_B + panel_C +
  plot_annotation(tag_levels = "A") +
  plot_layout(ncol = 3, widths = c(1, 1, 1))

# Display on screen
print(fig)

# ---- 7. Save to file ----
ggsave(
  "crqa_three_panel.pdf",
  plot   = fig,
  width  = 12,    # inches
  height = 4,
  dpi    = 300
)

ggsave(
  "crqa_three_panel.png",
  plot   = fig,
  width  = 12,
  height = 4,
  dpi    = 300
)

cat("Done! Files saved: crqa_three_panel.pdf  /  crqa_three_panel.png\n")


ggsave("panel_A_binary_sequences.pdf", plot = panel_A, width = 5, height = 3.5, dpi = 300)
ggsave("panel_A_binary_sequences.png", plot = panel_A, width = 5, height = 3.5, dpi = 300)

ggsave("panel_B_cross_recurrence.pdf", plot = panel_B, width = 5, height = 5, dpi = 300)
ggsave("panel_B_cross_recurrence.png", plot = panel_B, width = 5, height = 5, dpi = 300)

ggsave("panel_C_lagged_profile.pdf", plot = panel_C, width = 5, height = 3.5, dpi = 300)
ggsave("panel_C_lagged_profile.png", plot = panel_C, width = 5, height = 3.5, dpi = 300)

cat("Individual panels saved:\n")
cat("  panel_A_binary_sequences.pdf / .png\n")
cat("  panel_B_cross_recurrence.pdf / .png\n")
cat("  panel_C_lagged_profile.pdf   / .png\n")
