defmodule Example.Attribute do
  use XmlSchema, tag: "a"

  xml do
    xml_tag :k, :string
    xml_tag :j, {:param, :string}
    xml_tag :manyj, {:array, {:param, :string}}
  end

  def doc do
    """
      <a first="lemon" second="lime">
        <k third="peach">one</k>
        <j fourth="orange">tree</j>
        <manyj five="cherry">shrub</manyj>
        <manyj six="berry">flower</manyj>
      </a>
    """
  end

  def expect do
    %Example.Attribute{
      _attributes: %{"first" => "lemon", "second" => "lime"},
      k: "one",
      j: {"tree", %{"fourth" => "orange"}},
      manyj: [
        {"shrub", %{"five" => "cherry"}},
        {"flower", %{"six" => "berry"}}
      ]
    }
  end

  def expect_xml do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <a first="lemon" second="lime">
      <k>one</k>
      <j fourth="orange">tree</j>
      <manyj five="cherry">shrub</manyj>
      <manyj six="berry">flower</manyj>
    </a>
    """
    |> String.trim_trailing()
  end
end
