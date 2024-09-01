defmodule Example.Tag do
  use XmlSchema, tag: "a"

  xml do
    xml_tag :k, :string
  end

  def doc do
    """
      <a>
        <k>one</k>
      </a>
    """
  end

  def expect do
    %Example.Tag{_attributes: nil, k: "one"}
  end

  def expect_xml do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <a>
      <k>one</k>
    </a>
    """
    |> String.trim_trailing()
  end
end
