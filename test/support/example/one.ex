defmodule Example.One do
  use XmlSchema, tag: "a"

  xml do
    xml_one :j, Example.Tag
    xml_one :s, Example.Tag
  end

  def doc do
    """
    <a>
      <j>
        <k>one</k>
      </j>
    </a>
    """
  end

  def expect do
    %Example.One{
      _attributes: nil,
      j: %Example.Tag{_attributes: nil, k: "one"},
      s: nil
    }
  end

  def expect_xml do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <a>
      <j>
        <k>one</k>
      </j>
    </a>
    """
    |> String.trim_trailing()
  end
end
