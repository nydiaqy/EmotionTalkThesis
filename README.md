# Emotion Lexicon Socialization Across Development: The Role of Conversational Partners in Children's Emotion Talk

This repository contains the analysis pipeline for a thesis examining emotion word use in naturalistic child–partner conversations, using the CHILDES English-North America corpus.

---

## Research Questions

- **RQ1** — How do different conversational partners (by role) use emotion words when talking with target children of different ages? (negative binomial mixed-effects model)
- **RQ2** — Do emotion words recur across conversational turns? (CRQA)
- **RQ3** — Is there a directional influence in emotion word use between children and partners? (CRQA)

---

## Dataset

- **Source:** CHILDES English-North America, accessed via the [`childesr`](https://github.com/langcog/childes-db) package (database version 2021.1)
- **Emotion word list:** Clore, Ortony & Foss (1987) Affective Lexicon — `1987-Affectivelexicon-foundations_words.csv`

---

## Prerequisites

**R packages** (loaded via `00_setup.R`):
`here`, `childesr`, `dplyr`, `tidyr`, `purrr`, `stringr`, `ggplot2`, `quanteda`, `irlba`, `spacyr`, `tidyverse`, `lme4`, `glmmTMB`, `crqa`

**Python** (required for spaCy disambiguation):
```bash
pip install spacy sentence-transformers
python -m spacy download en_core_web_sm
```

---

## Repository Structure

```
ThesisDataAnalysis/
├── 00_setup.R                          # Load all packages
├── 00ThesisDataAnalysis.Rproj          # R project file
├── 1987-Affectivelexicon-foundations_words.csv
│
├── 01Data/
│   ├── 01Childes/                      # Raw CHILDES data (downloaded by 01LoadData.R)
│   └── 02Derived/                      # Intermediate & processed data
│       ├── 01Dataframe/                # Per-word utterance subsets (spaCy input)
│       ├── 02Spacy Parsed/             # spaCy POS/dependency parse results
│       ├── 03Annotation/               # Word-level annotation counts
│       ├── 04S-BERT Scored/            # S-BERT cosine similarity scores
│       ├── 05Manual Inspectation/      # Manual review files
│       ├── Amb_words_examples.xlsx     # Ambiguous word examples
│       └── Manual-checked.xlsx         # Manual coding results
│
├── 02Script/                           # Analysis scripts (run in order)
│   ├── 01LoadData.R
│   ├── 02Demographics.qmd
│   ├── 03RoleMap.R
│   ├── 04RQ1_utt_emotion.R
│   ├── 05RQ1Pipeline.qmd
│   ├── 06SpacyRTagging_RQ1.R
│   ├── 07RQ1DataAnalysis.qmd
│   ├── 08RQ2DataAnalysisCRQA.Rmd
│   └── m_main_nb_glmmTMB.rds           # Fitted glmmTMB model
│
└── 03Output/                           # Figures and summary tables
```

> **Note:** Several large `.rds` files (>50 MB) are excluded from this repository but are required to run the pipeline from intermediate steps. See [Large Files](#large-files) below.

---

## Pipeline

Run scripts in the following order from the R project root.

### Step 1 — Load raw data
**`02Script/01LoadData.R`**

Downloads transcripts, utterances, and target child participant data from CHILDES via the `childesr` API. Saves to `01Data/01Childes/`.

```
Outputs:
  01Data/01Childes/d_eng_na_transcripts.rds
  01Data/01Childes/ut_eng_na_utterances.rds   # 97 MB — excluded from git
  01Data/01Childes/d_target_child.rds
```

### Step 2 — Demographics
**`02Script/02Demographics.qmd`**

Descriptive statistics: transcript count, utterance counts by speaker role.

### Step 3 — Role mapping
**`02Script/03RoleMap.R`**

Defines `role_category_map`, mapping raw CHILDES `speaker_role` values to seven categories used throughout the analysis:

| Category | CHILDES Roles |
|---|---|
| Target Child | Target_Child |
| Mother | Mother |
| Father | Father |
| Sibling | Sister, Brother, Sibling |
| Known Adult | Grandmother, Grandfather, Relative, Caretaker, Caregiver, Teacher |
| Other Child | Child, Friend, Playmate, Student, Girl, Teenager |
| Other Adult | Unidentified, Adult, Media, Visitor, Participant, Environment, Male, Uncertain, Investigator |

Sourced automatically by later scripts via `source(here("02Script", "03RoleMap.R"))`.

### Step 4 — Emotion word counts
**`02Script/04RQ1_utt_emotion.R`**

- Excludes transcripts where only the target child speaks (no conversational partner)
- Counts occurrences of each emotion word (whole-word regex) per utterance
- Saves utterance-level dataframe with one column per emotion word

```
Output: 01Data/02Derived/utt_partners_emotions.rds   # 124 MB — excluded from git
```

### Step 5 — RQ1 disambiguation pipeline
**`02Script/05RQ1Pipeline.qmd`**

Merges disambiguation results (spaCy POS corrections and S-BERT scores) back into the main dataframe. Produces the cleaned final dataset used in statistical modelling.

```
Output: 01Data/02Derived/FINAL_utt_RQ1_emotions_merged.rds   # 125 MB — excluded from git
```

### Step 6 — Disambiguation: spaCy POS tagging
**`02Script/06SpacyRTagging_RQ1.R`**

Applies `spacyr` POS and dependency parsing to utterances containing high-frequency ambiguous emotion words. Word-level inclusion/exclusion rules:

| Word | Kept when | Excluded when |
|---|---|---|
| *like* | POS = VERB, or modal preference question (*would/do/can you like…*) | All other POS (ADP, discourse marker) |
| *well* | POS = ADJ or ADV | Sentence-initial, standalone, or *as well* constructions |
| *kind* | POS = ADJ | Category use (e.g., *that kind of…*) |
| *fine* | Followed by a noun | Standalone / sentence-initial (discourse management) |

Parse results saved per word to `01Data/02Derived/02Spacy Parsed/`.

For words where POS tagging is insufficient (*blue*, *high*, *low*, *lost*, *quiet*), **S-BERT semantic similarity** is used: utterances are embedded with `all-MiniLM-L6-v2` and classified by cosine similarity to emotion vs. non-emotion prototype sentences. Scored outputs saved to `01Data/02Derived/04S-BERT Scored/`.

### Step 7 — RQ1 statistical analysis
**`02Script/07RQ1DataAnalysis.qmd`**

- Descriptive statistics: emotion word frequencies per 1,000 words, by role
- Negative binomial mixed-effects model via `glmmTMB`
- Fitted model saved as `02Script/m_main_nb_glmmTMB.rds`
- Summary tables and figures saved to `03Output/`

### Step 8 — RQ2/RQ3 CRQA analysis
**`02Script/08RQ2DataAnalysisCRQA.Rmd`**

Cross-recurrence quantification analysis (CRQA) on turn-level emotion word counts, comparing target child turns against social partner turns.

---

## Large Files

These files exceed GitHub's 50 MB threshold and are excluded from the repository via `.gitignore`. They are kept locally as intermediate checkpoints — R scripts can resume from any step without rerunning the full pipeline from scratch.

| File | Size | Produced by |
|---|---|---|
| `01Data/01Childes/ut_eng_na_utterances.rds` | 97 MB | `01LoadData.R` |
| `01Data/02Derived/utt_partners_emotions.rds` | 124 MB | `04RQ1_utt_emotion.R` |
| `01Data/02Derived/utt_partners_emotions_merged.rds` | 125 MB | `05RQ1Pipeline.qmd` |
| `01Data/02Derived/FINAL_utt_RQ1_emotions_merged.rds` | 125 MB | `05RQ1Pipeline.qmd` |
| `01Data/02Derived/FINAL_utt_partners_emotions_merged.rds` | 83 MB | `05RQ1Pipeline.qmd` |
| `01Data/02Derived/utt_child_emotions.rds` | 43 MB | `04RQ1_utt_emotion.R` |

To reproduce these files, run the pipeline from Step 1.

---

## Outputs

All final figures and tables are in `03Output/`:

| File | Description |
|---|---|
| `emotion word count and frequency.csv` | Overall emotion word counts and frequency per 1,000 words |
| `emotion word count and frequency_by role.csv` | Emotion word frequency broken down by speaker role |
| `MERGED emotion word count and frequency.csv` | Post-disambiguation merged frequency table |
| `Emotion Word Use.png` | Overall emotion word use plot |
| `Emotion Word Use by Parent.png` | Emotion word use — Mother and Father vs target child age |
| `Emotion Word Use by Children.png` | Emotion word use — child social partners (siblings and other children) |
| `Emotion Word Use by Adult.png` | Emotion word use — non-parent adult partners (Known Adult, Other Adult) |
| `fig_role_distribution.png` | Distribution of speaker roles across transcripts |
