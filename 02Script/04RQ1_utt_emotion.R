
source(here("02Script", "03RoleMap.R"))
#exclude transcripts where only children are speaking

onlychild_ids <- ut_eng_na %>%
  group_by(transcript_id) %>%
  summarise(only_child = all(speaker_code == "CHI")) %>%
  filter(only_child == TRUE) %>%
  pull(transcript_id)

length(onlychild_ids)

ut_eng_na_rq1 <- ut_eng_na %>%
  filter(!transcript_id %in% onlychild_ids) %>%   
  left_join(role_category_map, by = "speaker_role") #add new role category

ut_eng_na_rq1 %>%
  summarise(
    n_transcripts = n_distinct(transcript_id),
    n_children    = n_distinct(target_child_id),
    n_utterances  = n()
  )


## Demo RQ1:

ut_eng_na_rq1 %>%
  distinct(target_child_id, target_child_sex) %>%
  count(target_child_sex)

# Age range in months and years (from child utterance rows only)
ut_eng_na_rq1 %>%
  filter(speaker_role == "Target_Child") %>%
  summarise(
    min_age_months = min(target_child_age, na.rm = TRUE),
    max_age_months = max(target_child_age, na.rm = TRUE),
    min_age_years  = round(min(target_child_age, na.rm = TRUE) / 12, 1),
    max_age_years  = round(max(target_child_age, na.rm = TRUE) / 12, 1),
    mean_age_months = round(mean(target_child_age, na.rm = TRUE), 1),
    sd_age_months   = round(sd(target_child_age, na.rm = TRUE), 1)
  )
#Create target word list

file_lex <- read.csv("~/Desktop/R_WD/ThesisDataAnalysis/1987-Affectivelexicon-foundations_words.csv",
                     stringsAsFactors = FALSE)
emotion_words <-file_lex$Word
emotion_words <- unique(na.omit(emotion_words))
head(emotion_words)
length(emotion_words)

#add emotion counts
utt_partners_emotions <- ut_eng_na_rq1 %>%
  mutate(
    gloss_lower = tolower(gloss),
    emotion_count = stringr::str_count(
      gloss_lower,
      paste0("\\b(", paste(emotion_words, collapse = "|"), ")\\b")
    )
  )

#add lower case utterance
gloss_vec <- utt_partners_emotions$gloss_lower

emotion_cols <- purrr::map_dfc(emotion_words, ~ {
  stringr::str_count(gloss_vec, paste0("\\b", .x, "\\b"))
}) %>%
  rlang::set_names(emotion_words)

utt_partners_emotions <- dplyr::bind_cols(utt_partners_emotions, emotion_cols)

saveRDS(utt_partners_emotions, here("01Data", "02Derived", "utt_partners_emotions.rds"))

