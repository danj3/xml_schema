defmodule XmlSchema.Type.StringTrim do
  @moduledoc """
  Trims input strings of whitespace. Can be a common occurance in
  some Xml documents.
  """

  use Ecto.Type

  def type, do: :string

  def cast(string) when is_binary(string),
    do: String.trim(string)

  def cast(string) when is_list(string),
    do: String.trim(List.to_string(string))

  def dump(string), do: string

  def equal?(a, b), do: a == b

  def load(string), do: string
end
