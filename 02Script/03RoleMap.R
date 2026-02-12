role_category_map <- tibble::tibble(
  speaker_role = c(
    "Mother","Father",
    "Grandmother","Grandfather","Relative","Caretaker","Caregiver","Teacher",
    "Sister","Brother","Sibling",
    "Child","Friend","Playmate","Student","Girl","Teenager",
    "Unidentified","Adult","Media","Visitor",
    "Participant","Environment","Male","Uncertain","Investigator"
  ),
  role_category = c(
    "MOT","FAT",
    rep("ADT", 6),
    rep("SIB", 3),
    rep("OTH_C", 6),
    rep("OTH_A", 9)
  )
)
