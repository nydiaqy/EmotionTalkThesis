role_category_map <- tibble::tibble(
  speaker_role = c(
    "Mother","Father",
    "Teacher","Grandmother","Relative","Grandfather","Caretaker","Target_Adult",
    "Sister","Brother","Sibling",
    "Child","Friend","Playmate","Boy","Girl","Student",
    "Investigator","Participant","Adult","Unidentified",
    "Other","Media","Visitor","Environment","Male", "Female", "Group", "Doctor", "Uncertain","Target_Child"
 ),
  role_category = c(
    "Mother","Father",
    rep("Known Adult", 6),
    rep("Sibling", 3),
    rep("Other Child", 6),
    rep("Other Adult", 13),
    rep("Target Child")
  )
)




