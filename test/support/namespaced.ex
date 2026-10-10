defmodule Namespaced do
  use XmlSchema, tag: "Envelope"

  xml do
    xml_one :Header, Header do
      xml_tag :Trace, {:param, :string}
    end

    xml_one :Body, Body do
      xml_one :Order, Order do
        xml_tag :Id, :integer

        xml_many :Line, Line do
          xml_tag :Sku, :string
        end
      end
    end
  end
end
