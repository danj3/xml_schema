defmodule Example.OneBlock do
  use XmlSchema, tag: "a"

  xml do
    xml_one :j, Tag do
      xml_tag :k, :string
    end
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
    %Example.OneBlock{
      _attributes: nil,
      j: %Example.OneBlock.Tag{_attributes: nil, k: "one"}
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
