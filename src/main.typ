#import "@preview/pesha:0.4.0": *

// load some data from non-public files, like mobile number, address and full
// name
#let data = sys.inputs.at("data", default: none)
#assert.ne(
  data, none,
  message: "Must specify `data` input that selects a file in `assets`",
)

#let data = toml("/assets/" + data + ".toml")

// See: https://github.com/talal/pesha/pull/2
#set grid(align: horizon)
#set text(lang: "en", number-type: "old-style", ligatures: true)

#let contacts = (
  data.mobile,
  link("mailto:" + data.email),
  {
    box(image("/assets/images/github.svg", height: 1em), baseline: 0.2em)
    link("github.com/" + data.github, data.github)
  },
)

#show: pesha.with(
  name: data.name,
  address: data.address,
  contacts: if contacts.len() != 0 { contacts },

  // only show prefix if there are multiple pages
  footer-text: context if counter(page).final().first() > 1 [Page],
  page-numbering-format: "1 of 1",
)

#include "parts/occupation.typ"
#include "parts/education.typ"
