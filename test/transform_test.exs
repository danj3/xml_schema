defmodule TransformTest do
  use ExUnit.Case

  @input "test/xml/permuted.xml"
  @input_struct %Permuted{
    _attributes: %{"creator" => "danj"},
    SingleTag: "hello",
    Items: %Permuted.Items{
      _attributes: nil,
      fake: [
        %Permuted.Items.Item{_attributes: %{"_tag" => "item1"}, Field: "a"},
        %Permuted.Items.Item{_attributes: %{"_tag" => "item2"}, Field: "b"}
      ]
    }
  }

  test "single input tag" do
    assert @input_struct == Permuted.parse_xml(File.read!(@input))
    assert ["Items", "SingleTag"] == Permuted.xml_string_tag_list()
    assert :SingleTag == Permuted.get_tag("SingleTag")
    assert :fake == Permuted.Items.get_tag("fake")
    assert nil == Permuted.Items.get_tag("item1")
  end
end
