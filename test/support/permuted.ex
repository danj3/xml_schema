defmodule Permuted.Items do
  use XmlSchema, transform: &transform/1

  @doc """
  input tags are premuted, item1, item2, rewrite them to a :fake tag
  save the original tag in the _tag attribute
  """

  def transform(_tag), do: "fake"

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
