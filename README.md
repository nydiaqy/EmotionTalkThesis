---
editor_options: 
  markdown: 
    wrap: 72
---

## **Thesis: are children more likely to talk about emotion when their conversational partner do?**

RQ1: Partner use of emotion words

RQ2: CRQA, recurrence of emotion words

RQ3: CRQA, direction of emotion words influence

**Dataset**:

CHILDES - English - North America

Transcript:

Word Count:

**Participant information :**

Target Children: Age, Sex

Conversational Partner: Role, SES, education

**conversational partner categorisation:**

**Word List:**

1987 Affective Lexicon Foundation

<https://langcog.github.io/childes-db-website/api.html>

### **RQ1 PIPELINE**

**Data Preparation:**

Transcript: exclude if only target child produced words

Extract conversational partner utterances

Groups back based on transcript -\> word count by transcript

Create target word list -\> Clore and Collegue 1987

key dataframe: counts of each emotion words per utterance:
utt_partners_emotions saved as xxx

counts of each emotion words in total

### Problem 1. Disambiguation

#### Rationale

Some emotion-related words in conversational English are polysemous and
frequently occur in non-emotional contexts (e.g., *like* as a discourse
marker or comparator). Including these uses risks inflating emotion-word
counts. Therefore, a targeted disambiguation procedure was applied to a
subset of potentially ambiguous emotion words.Manually go through 20
example utterances in each of the 100 emotion word to identify usage
pattern

### Step 1: Identifying potentially ambiguous emotion words

1.  Emotion words were first ranked by overall frequency.
2.  The **top 100 emotion words** were examined.
3.  For each candidate word, **20 example utterances** were manually
    inspected.
    <!--# To be considered: as part of screening, take 20 examples from all emotion words, 1. ask spacyr to tag POS, those appearing with multiple POS usage can be then manually examined 2. cross referencing with LIWC-->
4.  Words that frequently appeared in **non-emotional, discourse,
    comparative, or pragmatic uses** were flagged as *potentially
    ambiguous*.

-\> **sub-list of ambiguous emotion words**, which were subjected to
further disambiguation.

<div>

**Rationale**: First, many emotion words are used almost exclusively in
emotional contexts; applying disambiguation to these items would add
complexity without improving measurement precision. Second, prior
research consistently shows that emotion words are relatively rare in
naturalistic conversation, and that higher-frequency emotion words are
more likely to be polysemous and to occur in non-emotional discourse
contexts (e.g., as discourse markers or comparatives).

</div>

### Step 2: Creating a Subset of utterances containing **ambiguous** words

A sub-dataframe was created containing only utterances that included at
least one ambiguous emotion word. Only utterance-level identifiers and
relevant linguistic fields were retained.

<div>

**Rationale**: This reduced dataset allowed targeted experimentation
without modifying the full corpus.To improve computational efficiency
and focus analyses on relevant cases:

</div>

### Step 3: Method 1 — Unsupervised NLP (exploratory)

#### 3.1 Utterance-level clustering

As an exploratory approach, unsupervised clustering was applied to

-   full utterances containing ambiguous words

-   using sentence embeddings and clustering

#### 3.2 Context-window clustering

To increase sensitivity to local usage:

-   **context windows** of ±3 tokens (k = 3) were extracted around
    ambiguous words

<!-- -->

-   clustering was repeated at the **window level**

#### 3.3 Word-specific refinement (“like”)

Given the high frequency and polysemy of *like*, analyses were refined
by:

-   excluding fixed constructions such as *“look(s) like”*

-   removing discourse fillers (e.g., *“um”*)

-   re-running clustering on the cleaned subset

Cluster outputs and diagnostics were saved for documentation and
discussion：

e.g. ambiguous_utterance_clustered.csv

<div>

**Outcome**: While clustering revealed broad usage patterns, clusters
were not sufficiently aligned with semantic distinctions of interest to
serve as a definitive disambiguation method.

</div>

### Step 4: Method 2 — POS and dependency-based disambiguation (spaCy) (used in the coding)

Given the limitations of unsupervised clustering, a **rule-based
linguistic approach** was applied to the word *like* using **spaCy via
spacyr**.

#### 4.1 POS-based filtering

spaCy part-of-speech tags were used to identify the grammatical role of
*like.* Uses of *like* were retained **only when tagged as a VERB**,
corresponding to preference or affective meaning (e.g., *“I like
apples”*)

#### 4.2 Error inspection: Preference-question exception

Error inspection revealed that spaCy occasionally tagged *like* as an
adposition in **polite preference constructions** (e.g., *“would you
like one?”*).\

To retain these affectively relevant uses, an additional rule was
applied to include:

modal preference questions (*would/do/can you like …*)

All other POS categories (e.g., ADP, discourse-marker uses) were
excluded.

#### Word-level Rules 

+----------------+-----------------+----------------+----------------+
| Word           | Inclusion Rules | Exclusion      | Notes          |
|                | (1st)           | Rules (2nd)    |                |
+================+=================+================+================+
| Like           | POS=VERB + if   |                |                |
|                | used as a       |                |                |
|                | preference      |                |                |
|                | checking        |                |                |
|                | (would\|could   |                |                |
|                | \|can\|do\|did) |                |                |
+----------------+-----------------+----------------+----------------+
| Well           | POS = ADJ + ADV | single-word    |                |
|                | (he is doing    | utterances     |                |
|                | well)           | (e.g. well.),  |                |
|                |                 | se             |                |
|                |                 | ntence-initial |                |
|                |                 | (e.g. well     |                |
|                |                 | this is        |                |
|                |                 | because... )   |                |
|                |                 | as well (e.g.  |                |
|                |                 | I like it as   |                |
|                |                 | well; i like a |                |
|                |                 | as well as b)  |                |
+----------------+-----------------+----------------+----------------+
| Kind           | POS = ADJ       | category word  | still          |
|                |                 | (e.g."that     | including      |
|                |                 | kind" )        | (e.g.          |
|                |                 |                | strawberry     |
|                |                 |                | kind) may need |
|                |                 |                | to explicitly  |
|                |                 |                | exclude.       |
+----------------+-----------------+----------------+----------------+
|                |                 |                |                |
+----------------+-----------------+----------------+----------------+
|                |                 |                |                |
+----------------+-----------------+----------------+----------------+

#### 

rules:

Now trying 30th Dec (NLP) - clustering not making sense as its based on
utterances, not related to word-level usage

1.  whole utterance, clustered into 5 -\> saved as
    ambiguous_utterance_clustered.csv

2.  +- 3 words window, saved as

Options: part of speech tagging, rule-based exclusion, machine learning

-   problem 2. not based on partner

-\> roles

Total word count:

-   problem 1. not by roles

-   problem 2. might be embedded within frequency count

Identify target words list

Group conversational partner

### RQ2 and RQ3 PIPELINE
