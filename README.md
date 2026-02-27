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

 

+--------------+------------------------------------------------------+
| **Category​** | **Original Speaker Role in Data​**                    |
+--------------+------------------------------------------------------+
| Target ​      | Target Child​                                         |
|              |                                                      |
| Child​        |                                                      |
+--------------+------------------------------------------------------+
| Mother​       | Mother ​                                              |
+--------------+------------------------------------------------------+
| Father​       | Father​                                               |
+--------------+------------------------------------------------------+
| Sibling​      | Sister, Brother, Sibling​                             |
+--------------+------------------------------------------------------+
| Known ​       | Grandmother, Grandfather, Relative, Caretaker,       |
|              | Caregiver, Teacher​                                   |
| Adult​        |                                                      |
+--------------+------------------------------------------------------+
| Other ​       | Unidentified, Adult, Media, Visitor, Participant,    |
|              | Environment, Male, Uncertain, Investigator​           |
| Adult​        |                                                      |
+--------------+------------------------------------------------------+
| Other ​       | Child, Friend, Playmate, Student, Girl, Teenager​     |
|              |                                                      |
| Child​        |                                                      |
+--------------+------------------------------------------------------+

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
2.  The **emotion words** \> 10 were examined.
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

### Step 2: Creating a subset of utterances containing ambiguous words

A sub-dataframe was created containing the ambiguous words greater than
10 times. Only utterance-level identifiers and relevant linguistic
fields were retained. Identify ambiguous words. Words with low frequency
(\< 100 tokens) -\> *manual coding (*higher accuracy, feasible workload)
Words with high frequency (≥ 100 tokens) -\> *automated disambiguation
(spaCy)*

low frequency:

|         |     |     |     |     |
|:--------|----:|-----|-----|-----|
| rotten  |  75 |     |     |     |
| pride   |  63 |     |     |     |
| alarm   |  60 |     |     |     |
| ill     |  39 |     |     |     |
| tender  |  39 |     |     |     |
| crushed |  15 |     |     |     |
| gloomy  |  13 |     |     |     |
| meek    |  12 |     |     |     |
| faint   |     |     |     |     |

<div>

**Rationale**: This reduced dataset allowed targeted experimentation
without modifying the full corpus.To improve computational efficiency
and focus analyses on relevant cases:

</div>

share **identical syntactic frames**

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

+---------------+---------------+---------------+---------------+
| Word          | Inclusion     | Exclusion     | Notes         |
|               | Rules (1st)   | Rules (2nd)   |               |
+===============+===============+===============+===============+
| Like          | POS=VERB + if |               |               |
|               | used as a     |               |               |
|               | preference    |               |               |
|               | checking      |               |               |
|               | (             |               |               |
|               | would\|could\ |               |               |
|               | \|            |               |               |
|               | can\|do\|did) |               |               |
+---------------+---------------+---------------+---------------+
| Well          | POS = ADJ +   | single-word   |               |
|               | ADV (he is    | utterances    |               |
|               | doing well)   | (e.g. well.), |               |
|               |               | se            |               |
|               |               | n             |               |
|               |               | tence-initial |               |
|               |               | (e.g. well    |               |
|               |               | this is       |               |
|               |               | because... )  |               |
|               |               | as well (e.g. |               |
|               |               | I like it as  |               |
|               |               | well; i like  |               |
|               |               | a as well as  |               |
|               |               | b)            |               |
+---------------+---------------+---------------+---------------+
| Kind          | POS = ADJ     | category word | still         |
|               |               | (e.g."that    | including     |
|               |               | kind" )       | (e.g.         |
|               |               |               | strawberry    |
|               |               |               | kind) may     |
|               |               |               | need to       |
|               |               |               | explicitly    |
|               |               |               | exclude.      |
+---------------+---------------+---------------+---------------+
| fine          | next token    | stand alone/  | Descriptive   |
|               | POS = Noun    | starting the  | adjective     |
|               |               | sentence      | (quality /    |
|               |               |               | aesthetic) “a |
|               |               |               | fine lady” “a |
|               |               |               | fine river” → |
|               |               |               | “fine” =      |
|               |               |               | property of   |
|               |               |               | an            |
|               |               |               | o             |
|               |               |               | bject/person, |
|               |               |               | not a         |
|               |               |               | psychological |
|               |               |               | state         |
|               |               |               | Standalone /  |
|               |               |               | turn-initial  |
|               |               |               | “fine”        |
|               |               |               | (discourse    |
|               |               |               | management)   |
|               |               |               | “fine.”       |
|               |               |               | “fine—okay,   |
|               |               |               | now count.”   |
+---------------+---------------+---------------+---------------+
| High / Blue   | ?             |               |               |
+---------------+---------------+---------------+---------------+

### **Step 4: S-BERT**

POS tagging removes many non-emotion uses, but some ambiguous words
(e.g., *blue, high, low, lost*) stay ambiguous even with the same POS
(often adjectives). This step adds **context-sensitive disambiguation**
so we don’t wrongly count non-emotion meanings as emotion talk. **Step
1 - Subset utterances for the target ambiguous word**

Filter the utterance-level dataframe to rows where the word appears as a
**whole token** (e.g., \\\\bblue\\\\b).

**Rationale:** Disambiguation is only needed where the ambiguous word is
present; token matching avoids false matches (e.g., *blue* vs
*blueberry*).

**Step 2 — Define two sense prototypes (emotion vs non-emotion)**

Create two “anchors” representing the competing meanings (e.g.,
*blue-as-sad* vs *blue-as-color*).

-   Prototypes can be either:

    **(A) short researcher-defined reference texts**, or

    **(B) a small set of clearly unambiguous CHILDES utterances** for
    each sense.

-   **Rationale:** Turns disambiguation into a semantic similarity
    problem; CHILDES-based prototypes reduce phrasing bias and stay
    corpus-consistent.

**Step 3 — Embed utterances and prototypes using a sentence-embedding
model**

Use a pretrained **Sentence-Transformers** model (all-MiniLM-L6-v2) to
encode each utterance and each prototype into a fixed-length vector.

Rationale**:** Sentence embeddings capture **contextual meaning**,
allowing the same surface word (e.g., “blue”) to map differently
depending on surrounding words.

**Step 4 — Compute similarity to each prototype**

For each utterance, compute **cosine similarity** to the emotion
prototype and to the non-emotion prototype.

**Rationale:** Cosine similarity is standard for comparing embeddings;
it measures semantic closeness in the shared embedding space.

**Step 5 — Derive an “emotion-likeness” margin score and classify**

Compute margin = sim_emotion − sim_nonemotion.

Classify as **emotion-like** if margin \> 0; **non-emotion-like**
otherwise (optionally add a neutral band around 0).

**Rationale:** The margin gives an interpretable continuous score
(strength of evidence) and a simple transparent decision rule.

**Step 6 — Write results back to the dataset for downstream counting**

Add sim_emotion, sim_nonemotion, margin, and predicted_sense columns to
the utterance-level dataframe.

Use predicted_sense to **retain** only emotion-like uses for
emotion-word counts (or to exclude the word entirely if emotion-like
uses are rare).

**Rationale:** Keeps the pipeline reproducible and makes later
auditing/threshold tuning straightforward.

**Step 7 — Validation / audit (recommended)**

Manually inspect a sample of utterances near the decision boundary
(margin ≈ 0) and at both extremes.

Optionally estimate agreement by hand-labeling \~50–100 cases per word.

**Rationale:** Provides evidence that the automated rule aligns with
human judgments and identifies where prototypes/thresholds need
adjustment. rules:

+-----------+-----------------------+-----------+
| Word      | Mean                  | Original  |
|           |                       | N         |
+===========+=======================+===========+
| High      | ```                   | 830 -\> 0 |
|           | 0.09759036            |           |
|           |    Min. 1st Qu.  Med  |           |
|           | ian                   |           |
|           |  Mean 3rd Qu.    Max. |           |
|           | -0.4404 -0.2397 -0.1  |           |
|           | 514 -0                |           |
|           | .1485 -0.0687  0.1850 |           |
|           | ```                   |           |
+-----------+-----------------------+-----------+
| Blue      | ```                   | 4306      |
|           | 0.091268              |           |
|           |     Min.  1st Qu.     |           |
|           |    Med                |           |
|           | ian     Mean  3rd Qu. |           |
|           | -0.43059 -0.10753     |           |
|           |  -0.07                |           |
|           | 978 -0.07449 -0.03754 |           |
|           |     Max.              |           |
|           |  0.32633              |           |
|           | ```                   |           |
+-----------+-----------------------+-----------+
|           |                       |           |
+-----------+-----------------------+-----------+

"like","well","kind","blue","fine","merry","moved","certain","sore",
,"rotten","pride","tender","gloomy","meek","faint"

POS: "crushed" "alarm" "touched""patient""odd" "ill"

"high","blue","lost","quiet", "strong","low",

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

<Notes:level> of precision - actual emotion / all targeted as emotion

-\> how many do we need to review to feel confident?

Standard error

level of precision at 90%, 95% confidence interval -\> 220 utterance

### RQ2 and RQ3 PIPELINE
