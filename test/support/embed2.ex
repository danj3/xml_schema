defmodule Embed2 do
  use XmlSchema

  xml do
    xml_tag :EventHorizon, :string
    xml_many :Single, Single
  end
end
