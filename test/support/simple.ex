defmodule Simple do
  use XmlSchema, xml_name: "a",
    print: Mix.env() in [:test, :dev]

  xml do
    xml_tag :x, :string
    xml_tag :y, :boolean

    xml_one :z, Z do
      xml_tag :a, :string
      xml_tag :b, :string
    end

    xml_many :j, J do
      xml_tag :q, :string
    end

    xml_tag :g, {:array, :string}
  end
end
