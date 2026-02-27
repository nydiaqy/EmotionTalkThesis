role_category_map <- tibble::tibble(
  speaker_role = c(
    "Mother","Father",
    "Grandmother","Grandfather","Relative","Caretaker","Caregiver","Teacher",
    "Sister","Brother","Sibling",
    "Child","Friend","Playmate","Student","Girl","Teenager",
    "Unidentified","Adult","Media","Visitor",
    "Participant","Environment","Male","Uncertain","Investigator", "Target_Child"
  ),
  role_category = c(
    "Mother","Father",
    rep("Known Adult", 6),
    rep("Sibling", 3),
    rep("Other Child", 6),
    rep("Other Adult", 9),
    rep("Target Child")
  )
)
