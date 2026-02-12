source("00_setup.R")
amb_utt <- readRDS(here("01Data", "02Derived", "amb_utterances.rds"))

#Like

df_like <- amb_utt %>%
  filter(str_detect(gloss_lower, "\\blike\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_like$text
names(x) <- df_like$doc_id 

tok_like <- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_like, here("01Data", "02Derived", "02Spacy Parsed", "spacy_like_parsed.rds"))
saveRDS(df_like, here("01Data", "02Derived", "01Dataframe", "df_like_utterances.rds"))

#Well
df_well <- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bwell\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_well$text
names(x) <- df_well$doc_id 

tok_well <- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_well, here("01Data", "02Derived", "02Spacy Parsed", "spacy_well_parsed.rds"))
saveRDS(df_well, here("01Data", "02Derived", "01Dataframe", "df_well_utterances.rds"))



#Kind
df_kind <- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bkind\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_kind$text
names(x) <- df_kind$doc_id 

tok_kind<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_kind, here("01Data", "02Derived", "02Spacy Parsed", "spacy_kind_parsed.rds"))
saveRDS(df_kind, here("01Data", "02Derived","01Dataframe", "df_kind_utterances.rds"))



#Blue

df_blue <- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bblue\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_blue$text
names(x) <- df_blue$doc_id 

tok_blue<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_blue, here("01Data", "02Derived","02Spacy Parsed",  "spacy_blue_parsed.rds"))
saveRDS(df_blue, here("01Data", "02Derived", "01Dataframe","df_blue_utterances.rds"))



#fine
df_fine <- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bfine\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_fine$text
names(x) <- df_fine$doc_id 

tok_fine<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_fine, here("01Data", "02Derived", "02Spacy Parsed", "spacy_fine_parsed.rds"))
saveRDS(df_fine, here("01Data", "02Derived", "01Dataframe","df_fine_utterances.rds"))


#high

df_high <- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bhigh\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_high$text
names(x) <- df_high$doc_id 

tok_high<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_high, here("01Data", "02Derived", "02Spacy Parsed","spacy_high_parsed.rds"))
saveRDS(df_high, here("01Data", "02Derived", "01Dataframe", "df_high_utterances.rds"))



#lost
df_lost<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\blost\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_lost$text
names(x) <- df_lost$doc_id 

tok_lost<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)


saveRDS(tok_lost, here("01Data", "02Derived", "02Spacy Parsed", "spacy_lost_parsed.rds"))
saveRDS(df_lost, here("01Data", "02Derived", "01Dataframe", "df_lost_utterances.rds"))



#quiet
df_quiet<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bquiet\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_quiet$text
names(x) <- df_quiet$doc_id 

tok_quiet<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_quiet, here("01Data", "02Derived","02Spacy Parsed", "spacy_quiet_parsed.rds"))
saveRDS(df_quiet, here("01Data", "02Derived","01Dataframe", "df_quiet_utterances.rds"))



#sick
df_sick<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bsick\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_sick$text
names(x) <- df_sick$doc_id 

tok_sick<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_sick, here("01Data", "02Derived", "02Spacy Parsed", "spacy_sick_parsed.rds"))
saveRDS(df_sick, here("01Data", "02Derived","01Dataframe",  "df_sick_utterances.rds"))

#strong
df_strong<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bstrong\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_strong$text
names(x) <- df_strong$doc_id 

tok_strong<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_strong, here("01Data", "02Derived", "02Spacy Parsed", "spacy_strong_parsed.rds"))
saveRDS(df_strong, here("01Data", "02Derived", "01Dataframe",  "df_strong_utterances.rds"))




#gentle
df_gentle<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bgentle\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_gentle$text
names(x) <- df_gentle$doc_id 

tok_gentle<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_gentle, here("01Data", "02Derived","02Spacy Parsed",  "spacy_gentle_parsed.rds"))
saveRDS(df_gentle, here("01Data", "02Derived","01Dataframe", "df_gentle_utterances.rds"))


#merry
df_merry<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bmerry\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_merry$text
names(x) <- df_merry$doc_id 

tok_merry<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_merry, here("01Data", "02Derived","02Spacy Parsed",  "spacy_merry_parsed.rds"))
saveRDS(df_merry, here("01Data", "02Derived","01Dataframe", "df_merry_utterances.rds"))

#moved
df_moved<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bmoved\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_moved$text
names(x) <- df_moved$doc_id 

tok_moved<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_moved, here("01Data", "02Derived","02Spacy Parsed",  "spacy_moved_parsed.rds"))
saveRDS(df_moved, here("01Data", "02Derived","01Dataframe", "df_moved_utterances.rds"))


#low
df_low<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\blow\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_low$text
names(x) <- df_low$doc_id 

tok_low<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_low, here("01Data", "02Derived","02Spacy Parsed",  "spacy_low_parsed.rds"))
saveRDS(df_low, here("01Data", "02Derived","01Dataframe", "df_low_utterances.rds"))


#certain
df_certain<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bcertain\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_certain$text
names(x) <- df_certain$doc_id 

tok_certain<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_certain, here("01Data", "02Derived","02Spacy Parsed",  "spacy_certain_parsed.rds"))
saveRDS(df_certain, here("01Data", "02Derived","01Dataframe", "df_certain_utterances.rds"))




#touched
df_touched<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\btouched\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_touched$text
names(x) <- df_touched$doc_id 

tok_touched<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_touched, here("01Data", "02Derived","02Spacy Parsed",  "spacy_touched_parsed.rds"))
saveRDS(df_touched, here("01Data", "02Derived","01Dataframe", "df_touched_utterances.rds"))



#patient
df_patient<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bpatient\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_patient$text
names(x) <- df_patient$doc_id 

tok_patient<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_patient, here("01Data", "02Derived","02Spacy Parsed",  "spacy_patient_parsed.rds"))
saveRDS(df_patient, here("01Data", "02Derived","01Dataframe", "df_patient_utterances.rds"))


#Odd
df_odd<- amb_utt %>%
  filter(str_detect(gloss_lower, "\\bodd\\b")) %>%
  transmute(doc_id = as.character(id), text = gloss_lower)

x <- df_odd$text
names(x) <- df_odd$doc_id 

tok_odd<- spacy_parse(
  x,
  lemma = TRUE,
  pos = TRUE,
  dependency = TRUE
)

saveRDS(tok_odd, here("01Data", "02Derived","02Spacy Parsed",  "spacy_odd_parsed.rds"))
saveRDS(df_odd, here("01Data", "02Derived","01Dataframe", "df_odd_utterances.rds"))