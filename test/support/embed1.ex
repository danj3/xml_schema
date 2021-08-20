defmodule Embed1 do
  use XmlSchema

  xml do
    xml_tag :EventHorizon, :string
    xml_one :Single, Single
  end
end
