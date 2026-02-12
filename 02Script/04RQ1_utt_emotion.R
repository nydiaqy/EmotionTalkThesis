
source(here("02Script", "03RoleMap.R"))
#pull out all utterance for conversatioanl parnters
ut_eng_na_rq1 <- ut_eng_na %>%
  filter(!transcript_id %in% onlychild_ids) %>%   
  filter(speaker_role != "Target_Child") %>% 
  left_join(role_category_map, by = "speaker_role")      #add new role category

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

ut_eng_na <- readRDS(here("01Data", "01Childes", "ut_eng_na_utterances.rds"))
ut_eng_na_chi <- ut_eng_na %>%
  filter(speaker_role == "Target_Child")

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

