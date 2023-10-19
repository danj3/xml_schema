defmodule Permuted.Items do
  use XmlSchema, transform: &transform/1

  def transform(tag), do: ~c"fake"

  xml do
    xml_many :fake, Item do
      xml_tag :Field, :string
    end
  end
end

defmodule Permuted do
  use XmlSchema

  xml do
    xml_tag :SingleTag, :string
    xml_one :Items, Permuted.Items
  end
end
