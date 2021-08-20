defmodule Types do
  use XmlSchema

  xml do
    xml_tag :String, :string
    xml_tag :TrimString, XmlSchema.Type.StringTrim
    xml_tag :Integer, :integer
    xml_tag :Float, :float
    xml_tag :BooleanTrue, :boolean
    xml_tag :BooleanFalse, :boolean
    xml_tag :Atom, XmlSchema.Type.Atom
    xml_tag :Dollars, XmlSchema.Type.Cents
    xml_tag :NDollars, XmlSchema.Type.Cents
    xml_tag :Odollar, XmlSchema.Type.Cents
  end
end
