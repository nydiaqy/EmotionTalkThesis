#Testing emotion counts in children's transcript 

ut_eng_na <- readRDS(here("01Data", "01Childes", "ut_eng_na_utterances.rds"))
ut_eng_na_chi <- ut_eng_na %>%
  filter(speaker_role == "Target_Child")
ut_eng_na_chi
utt_child_emotions <- ut_eng_na_chi %>%
  mutate(
    gloss_lower = tolower(gloss),
    emotion_count = stringr::str_count(
      gloss_lower,
      paste0("\\b(", paste(emotion_words, collapse = "|"), ")\\b")
    )
  )

gloss_vec <- utt_child_emotions$gloss_lower

emotion_cols <- purrr::map_dfc(emotion_words, ~ {
  stringr::str_count(gloss_vec, paste0("\\b", .x, "\\b"))
}) %>%
  rlang::set_names(emotion_words)

utt_child_emotions <- dplyr::bind_cols(utt_child_emotions, emotion_cols)
saveRDS(utt_child_emotions, here("01Data", "02Derived", "utt_child_emotions.rds"))

df_child_tr <- utt_child_emotions %>%
  group_by(
    transcript_id,
    target_child_id,
    target_child_age,
    target_child_sex
  ) %>%
  summarise(
    emotion_count = sum(emotion_count, na.rm = TRUE),
    num_tokens    = df_rates %>% 
  filter(target_child_age_years < 1) %>% 
  summarise(mean_rate = mean(rate_per_1000_local))sum(num_tokens, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(num_tokens > 0)

m_child_nb <- glmmTMB(
  emotion_count ~
    ns(target_child_age, df = 3) +
    target_child_sex +
    offset(log(num_tokens)) +
    (1 | target_child_id),
  family = nbinom2(),
  data = df_child_tr
)
mean(df_child_tr$emotion_count / df_child_tr$num_tokens * 1000)
mean(utt_child_emotions$emotion_count / utt_child_emotions$num_tokens * 1000)
names(utt_child_emotions)
m_child_nb

speaker_stats_child <- get_speaker_statistics(
  collection = "Eng-NA"
  # leave role out first to make sure you get data
)

stats_chi <- speaker_stats_child %>%
  filter(speaker_role=="Target_Child")


child_tokens_per_tr <- stats_chi %>%
  group_by(transcript_id) %>%
  summarise(num_tokens_childes = sum(num_tokens, na.rm = TRUE), .groups = "drop")


df_rates <- df_child_tr %>%
  mutate(transcript_id = as.character(transcript_id)) %>%
  inner_join(
    child_tokens_per_tr %>% mutate(transcript_id = as.character(transcript_id)),
    by = "transcript_id"
  )
df_rates
df_rates <- df_rates %>%
  mutate(rate_per_1000_local = 1000 * emotion_count / num_tokens)
summary(df_rates$rate_per_1000_local)

# ---- 1) Build age grid within observed range ----
age_min_m <- min(df_child_tr$target_child_age, na.rm = TRUE)
age_max_m <- max(df_child_tr$target_child_age, na.rm = TRUE)

age_years  <- seq(age_min_m/12, age_max_m/12, by = 0.1)
age_months <- age_years * 12

# ---- 2) Choose a reference sex that exists ----
sex_levels <- levels(df_child_tr$target_child_sex)
if (is.null(sex_levels)) sex_levels <- sort(unique(df_child_tr$target_child_sex))
ref_sex <- sex_levels[1]  # change to "female" if that's your level

# ---- 3) New data for prediction (per 1,000 tokens) ----
new_child <- data.frame(
  target_child_age = age_months,
  target_child_sex = factor(ref_sex, levels = sex_levels),
  num_tokens = 1000
) %>%
  mutate(target_child_age_years = target_child_age/12)

# ---- 4) Predict fixed-effects only on link scale with SE ----
pred <- predict(
  m_child_nb,
  newdata = new_child,
  type = "link",
  se.fit = TRUE,
  re.form = NA
)

# ---- 5) Convert to response scale and build CI ----
new_child <- new_child %>%
  mutate(
    fit_link = pred$fit,
    se_link  = pred$se.fit,
    fit      = exp(fit_link),
    ci_lower = exp(fit_link - 1.96 * se_link),
    ci_upper = exp(fit_link + 1.96 * se_link)
  )

# ---- 6) Plot ----
p_child <- ggplot(new_child, aes(x = target_child_age_years, y = fit)) +
  geom_line(linewidth = 1) +
  geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), alpha = 0.2) +
  scale_x_continuous(breaks = seq(0, 12, by = 1),
                     limits = range(new_child$target_child_age_years)) +
  coord_cartesian(ylim = c(0, 50)) +
  labs(
    title = paste0("Predicted Child Emotion Words by Age (sex = ", ref_sex, ")"),
    x = "Age (years)",
    y = "Expected emotion words per 1,000 tokens"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

print(p_child)


df_rates %>% 
  +     filter(target_child_age < 12) %>% 
  +     summarise(mean_rate = mean(rate_per_1000_local))

age_summary_child <- df_rates %>%
  mutate(age_bin = floor(target_child_age / 12)) %>%
  group_by(age_bin) %>%
  summarise(
    n_transcripts = n(),
    mean_rate_per_1000 = mean(rate_per_1000_local, na.rm = TRUE),
    median_rate_per_1000 = median(rate_per_1000_local, na.rm = TRUE),
    max_rate_per_1000 = max(rate_per_1000_local, na.rm = TRUE)
  )
age_summary_child


#------------------------

short_tr <- df_child_tr %>%
  filter(num_tokens <= 5) %>%           # try <= 1, <= 2 as well
  count(num_tokens, sort = TRUE)

short_tr

rate_all <- 1000 * sum(df_child_tr$emotion_count) / sum(df_child_tr$num_tokens)

rate_50 <- df_child_tr %>%
  filter(num_tokens >= 50) %>%
  summarise(rate = 1000 * sum(emotion_count) / sum(num_tokens)) %>%
  pull(rate)

c(rate_all = rate_all, rate_50 = rate_50)
df_rates %>% 
  sum (emotion counts = 0 and emotion counts > 0)

#-------Craig's pipeline----------------
nrc_lexicon <- get_sentiments("nrc")
nrc_words <- unique(get_sentiments("nrc")$word)

emo_used_by_craig <- intersect(emotion_words, nrc_words)

emo_used_by_craig

extra_words_qy <- setdiff(
   tolower(emotion_words), tolower(emo_used_by_craig))
extra_words_qy

emotion_word_count_by_frequency <- read.csv("emotion word count and frequency.csv")

extra_word_freqs <- emotion_word_count_by_frequency %>%
  filter(word %in% extra_words_qy) %>%
  arrange(desc(freq_per_1000_words))
extra_word_freqs
sum(extra_word_freqs$freq_per_1000_words)
