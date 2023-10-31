# XmlSchema

🧽 (MOP)

XML Parser based on Ecto schemas

Parses XML documents directly into Ecto.Schema but with additional
layer of DSL to describe XML structure. All features from
Ecto.Schema can be used.

Purpose is to ease access to CDATA and attributes on input at the
sacrifice of precise access to all CDATA fragments that may exist
(as occurs with indentation). Tag parsing and generation order is
preserved based on the schema defined. Order of attributes are not
preserved and are stored as a map excluding multiple instances of
the same attribute in a single tag instance.

Terminal tags are available by default as bare values
(strings, integers, etc.), but does not allow for attributes. A
tuple container can be specified if attributes are needed resulting
in values of `{tag-value, attributes-map}`. The syntax to create this
container is `{:param, type}`, where type is a base type (like `:string`,
or a custom type).

# Sample

```elixir
defmodule Embed1 do
  use XmlSchema

  xml do
    xml_tag :EventHorizon, :string
    xml_one :Single, Single
  end
end
```

(Single is defined in tests/support/single.ex)

All XmlSchema instrumented modules provide `xml` outer declaration with inner
declarations of:

- `xml_tag` - A terminal XML node with CDATA values
- `xml_one` - A tag that contains one substructure
- `xml_many` - A tag that contains many of the named tag

Tags unspecified are ignored.

Above parses:

```xml
<?xml encoding="utf-8" ?>
<Embed1 creator="danj">
  <EventHorizon>No Light escapes</EventHorizon>
  <Name>Bob</Name>
  <Single complete="false">
    <Name>Bob</Name>
    <Address>123 Evergreen Terrace</Address>
    <Address>Apt 123</Address>
  </Single>
</Embed1>
```

and results in

```
%Embed1{
    _attributes: %{"creator" => "danj"},
    EventHorizon: "No Light escapes",
    Single: %Single{
      _attributes: %{"complete" => "false"},
      Name: "Bob",
      Address: ["123 Evergreen Terrace", "Apt 123"]
    }
  }
```

For examples look at test/xml, test/support

License

Copyright (c) 2023 Triskelion, LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
