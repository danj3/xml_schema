defmodule Example.Many do
  use XmlSchema, tag: "a"

  xml do
    xml_many :j, Example.Tag
    xml_many :s, Example.Tag
  end

  def doc do
    """
      <a>
        <j>
          <k>one</k>
        </j>
        <j>
          <k>two</k>
        </j>
      </a>
    """
  end

  def expect do
    %Example.Many{
      _attributes: nil,
      j: [
        %Example.Tag{_attributes: nil, k: "one"},
        %Example.Tag{_attributes: nil, k: "two"}
      ],
      s: []
    }
  end
  def expect_xml do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <a>
      <j>
        <k>one</k>
      </j>
      <j>
        <k>two</k>
      </j>
    </a>
    """
    |> String.trim_trailing()
  end
end
