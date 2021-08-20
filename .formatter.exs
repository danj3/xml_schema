# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  import_deps: [:ecto],
  locals_without_parens: [
    xml: 0,
    xml_tag: 2,
    xml_tag: 3,
    xml_one: 2,
    xml_one: 3,
    xml_many: 2,
    xml_many: 3
  ],
  export: [
    locals_without_parens: [
      xml: 0,
      xml_tag: 2,
      xml_tag: 3,
      xml_one: 2,
      xml_one: 3,
      xml_many: 2,
      xml_many: 3
    ]
  ]
]
