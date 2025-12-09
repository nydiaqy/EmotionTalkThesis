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

**Word List:**

1987 Affective Lexicon Foundation

<https://langcog.github.io/childes-db-website/api.html>

### **RQ1 PIPELINE**

**Data Preparation:**

Transcript: exclude if only target child produced words

Extract conversational partner utterances

Groups back based on transcript -\> word count by transcript

Create target word list -\> Clore and Collegue 1987

key dataframe: Identify counts of each emotion words per utterance

counts of each emotion words in total

### problem 1. emotion words are not used as an emotion word 

Manually go through 20 example utterances in each of the 50 emotion word
to identify usage pattern

Options: part of speech tagging, rule-based exclusion, machine learning

-   problem 2. not based on partner

-\> roles

Total word count:

-   problem 1. not by roles

-   problem 2. might be embedded within frequency count

Identify target words list

Group conversational partner

### RQ2 and RQ3 PIPELINE
