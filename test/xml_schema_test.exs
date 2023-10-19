defmodule XmlSchemaTest do
  use ExUnit.Case
  doctest XmlSchema

  test "greets the world" do
    assert Single.__struct__() == %Single{}
  end

  @tag :single
  test "parse single" do
    r = %Single{
      Address: ["123 Evergreen Terrace", "Apt 123"],
      Name: "Bob",
      _attributes: %{"complete" => "false"}
    }

    p = Single.parse_xml(File.read!("test/xml/single.xml"))
    assert p == r
    IO.inspect([parsed: p], pretty: true)
  end

  @tag :embed1
  test "parse embed1" do
    r = %Embed1{
      EventHorizon: "No Light escapes",
      Single: %Single{
        Address: ["123 Evergreen Terrace", "Apt 123"],
        Name: "Bob",
        _attributes: %{"complete" => "false"}
      },
      _attributes: %{"creator" => "danj"}
    }

    p = Embed1.parse_xml(File.read!("test/xml/embed1.xml"))
    assert p == r
    IO.inspect([parsed: p], pretty: true)
  end

  @tag :embed2
  test "parse embed2" do
    r = %Embed2{
      EventHorizon: "No Light escapes",
      Single: [
        %Single{
          Address: ["123 Evergreen Terrace", "Apt 123"],
          Name: "Bob",
          _attributes: %{"complete" => "false"}
        },
        %Single{
          Address: ["456 Evergreen Terrace", "Apt 789"],
          Name: "Fred",
          _attributes: %{"complete" => "false"}
        }
      ],
      _attributes: %{"creator" => "danj"}
    }

    p = Embed2.parse_xml(File.read!("test/xml/embed2.xml"))
    assert p == r
    IO.inspect([parsed: p], pretty: true)
  end

  @tag :types
  test "types" do
    r = %Types{
      BooleanFalse: false,
      BooleanTrue: true,
      Float: 1.53,
      Integer: 123,
      String: "Bob",
      TrimString: "foo",
      Atom: :free_atom,
      Dollars: 10616,
      NDollars: -5517,
      Odollar: 6112,
      _attributes: nil
    }

    p = Types.parse_xml(File.read!("test/xml/types.xml"))
    assert p == r
    IO.inspect([parsed: p], pretty: true)
  end

  @tag :simple
  test "simple example" do
    ref = %Simple{
      _attributes: %{"otherattr" => "red", "someattr" => "blue"},
      x: "hill",
      y: false,
      z: %Simple.Z{_attributes: nil, a: "tree", b: "bush"},
      j: [
        %Simple.J{_attributes: nil, q: "cat"},
        %Simple.J{_attributes: nil, q: "dog"}
      ],
      g: ["hippo", "elephant", "rhino"]
    }

    p = Simple.parse_xml(File.read!("test/xml/simple.xml"))
    IO.inspect(p)
    assert p == ref
  end
end
