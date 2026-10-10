defmodule NamespaceTest do
  use ExUnit.Case

  @input "test/xml/namespaced.xml"

  @soap "http://schemas.xmlsoap.org/soap/envelope/"
  @meta "urn:example:meta"
  @orders "urn:example:orders"
  @xml "http://www.w3.org/XML/1998/namespace"

  @namespaces %{@soap => "soap", @meta => "m", @orders => ""}

  @expect %Namespaced{
    _attributes: %{"_ns" => @soap},
    Header: %Namespaced.Header{
      _attributes: %{"_ns" => @soap},
      Trace: {"abc", %{"_ns" => @meta, "{#{@meta}}id" => "42"}}
    },
    Body: %Namespaced.Body{
      _attributes: %{"_ns" => @soap},
      Order: %Namespaced.Body.Order{
        _attributes: %{"_ns" => @orders, "status" => "open", "{#{@xml}}lang" => "en"},
        Id: 7,
        Line: [
          %Namespaced.Body.Order.Line{_attributes: %{"_ns" => @orders}, Sku: "A-1"},
          %Namespaced.Body.Order.Line{_attributes: %{"_ns" => @orders}, Sku: "B-2"}
        ]
      }
    }
  }

  setup_all do
    %{doc: File.read!(@input)}
  end

  test "parse keeps namespace uris in _ns and Clark notation attributes", %{doc: doc} do
    assert Namespaced.parse_xml(doc) == @expect
  end

  test "parse_xml_with_namespaces returns uri to prefix map", %{doc: doc} do
    assert Namespaced.parse_xml_with_namespaces(doc) == {@expect, @namespaces}
  end

  test "round trip reproduces the document with its prefixes", %{doc: doc} do
    {parsed, namespaces} = Namespaced.parse_xml_with_namespaces(doc)
    assert XmlSchema.generate_xml(parsed, namespaces: namespaces) == doc
  end

  test "without a namespace map, output binds generated prefixes and is equivalent", %{doc: doc} do
    gen = XmlSchema.generate_xml(Namespaced.parse_xml(doc))

    refute gen =~ "_ns"
    refute gen =~ "{"
    assert gen =~ ~s(<ns0:Envelope xmlns:ns0="#{@soap}">)
    assert gen =~ ~s(xml:lang="en")
    refute gen =~ "xmlns:xml"
    assert Namespaced.parse_xml(gen) == @expect
  end

  test "caller chosen prefixes are applied", %{doc: doc} do
    namespaces = %{@soap => "env", @meta => "meta", @orders => "o"}
    gen = XmlSchema.generate_xml(Namespaced.parse_xml(doc), namespaces: namespaces)

    assert gen =~
             ~s(<env:Envelope xmlns:env="#{@soap}" xmlns:meta="#{@meta}" xmlns:o="#{@orders}">)

    assert gen =~ ~s(<meta:Trace meta:id="42">abc</meta:Trace>)
    assert gen =~ ~s(<o:Order status="open" xml:lang="en">)
    assert Namespaced.parse_xml(gen) == @expect
  end

  test "default namespace on an attribute gets a prefix" do
    gen =
      XmlSchema.generate_xml(
        %Example.Tag{_attributes: %{"_ns" => @orders, "{#{@orders}}x" => "1"}, k: "v"},
        namespaces: %{@orders => ""}
      )

    assert gen =~ ~s(<a xmlns="#{@orders}" xmlns:ns0="#{@orders}" ns0:x="1">)
  end

  test "explicit top tag name with options" do
    gen =
      XmlSchema.generate_xml(%Example.Tag{_attributes: %{"_ns" => @orders}}, "b",
        namespaces: %{@orders => "o"}
      )

    assert gen =~ ~s(<o:b xmlns:o="#{@orders}"/>)
  end

  test "namespace map must be one-to-one" do
    assert_raise ArgumentError, ~r/bound to more than one uri/, fn ->
      XmlSchema.generate_xml(%Example.Tag{}, namespaces: %{"urn:a" => "p", "urn:b" => "p"})
    end

    assert_raise ArgumentError, ~r/reserved/, fn ->
      XmlSchema.generate_xml(%Example.Tag{}, namespaces: %{"urn:a" => "xmlns"})
    end
  end

  test "rebound prefixes keep the first binding" do
    doc = ~s(<a xmlns="urn:a"><k xmlns="urn:b">v</k></a>)
    assert {_parsed, %{"urn:a" => ""}} = Example.Tag.parse_xml_with_namespaces(doc)
  end

  test "hand built atom attribute keys still generate" do
    gen = XmlSchema.generate_xml(%Example.Tag{_attributes: %{color: "red"}, k: "v"})
    assert gen =~ ~s(<a color="red">)
  end
end
