defmodule XmlSchema.Precompile do
  @doc """
  This uses Enum/List, access is linear. For a lot of tags
  this will lose efficiency, but not knowing what the threshold
  for that is, an alternate use of Map is not included.
  """
  defmacro __before_compile__(env) do
    string_tags =
      for tag <- Module.get_attribute(env.module, :tag_order) do
        {Atom.to_string(tag), tag}
      end

    if length(string_tags) > 10 do
      ms = Map.new(string_tags)
      Module.put_attribute(env.module, :tag_string, ms)

      quote do
        def get_tag(string_tag),
          do: Map.get(@tag_string, string_tag)

        def xml_string_tag_list, do: Map.keys(@tag_string)
      end
    else
      Module.put_attribute(env.module, :tag_string, string_tags)

      quote do
        @doc "has tag, for parsing, strings"
        def get_tag(string_tag),
          do:
            Enum.find_value(
              @tag_string,
              fn {st, atm} ->
                if st == string_tag, do: atm, else: nil
              end
            )

        def xml_string_tag_list,
          do: Enum.map(@tag_string, &elem(&1, 0))
      end
    end
  end
end
