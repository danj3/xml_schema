defmodule ExampleTest do
  use ExUnit.Case

  def test_example(module) do
    result = module.parse_xml(module.doc())
    gen = XmlSchema.generate_xml(result)

    Help.do_inspect(
      doc: module.doc(),
      result: result,
      expect: module.expect(),
      generated: gen
    )

    assert result == module.expect()
    assert gen == module.expect_xml()
  end

  @tag :many
  test "xml_many" do
    test_example(Example.Many)
  end

  @tag :one
  test "xml_one" do
    test_example(Example.One)
  end

  @tag :one_block
  test "xml_one_block" do
    test_example(Example.OneBlock)
  end

  @tag :tag
  test "xml_tag" do
    test_example(Example.Tag)
  end

  @tag :attribute
  test "xml_attribute" do
    test_example(Example.Attribute)
  end
end
