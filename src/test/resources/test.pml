(
  (string "name")
  (boolean true)
  (cc "string")
  (dd atom)
  (
    arr
    (1 2 3 4)
  )(
    "arr_ob"
    (
      ( a 1 )
      ( a 2 )
      ( a 3 )
      ( a 4 )
    )
  )
)
(
  name "User"
  fields (
    (
      name "user_name"
      type String
    )
    (
      name "age"
      type Int
    )(
      name      "articles"
      inverse   "author"
      type      "Article"
      relation  HAS_MANY
    )
  )
)
(
  name "Article"
  fields (
    (
      name "author"
      type (Array )
    )
  )
)