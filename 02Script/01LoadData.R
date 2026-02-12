source("00_setup.R")
#Load CHILDES transcripts/ utterance dataframe in English-North America
#database version: '2021.1'
d_eng_na  <- get_transcripts(collection = "Eng-NA")
ut_eng_na <- get_utterances(collection = "Eng-NA")
d_target_child <- get_participants(role = "target_child", collection = "Eng-NA")

saveRDS(d_eng_na,  here("01Data", "01Childes", "d_eng_na_transcripts.rds"))
saveRDS(ut_eng_na, here("01Data", "01Childes", "ut_eng_na_utterances.rds"))
saveRDS(d_target_child, here("01Data", "01Childes", "d_target_child.rds"))
