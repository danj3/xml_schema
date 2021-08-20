defmodule Single do
  use XmlSchema, tag: "single"

  xml do
    xml_tag :Name, :string
    xml_tag :Address, { :array, :string }
  end
end
