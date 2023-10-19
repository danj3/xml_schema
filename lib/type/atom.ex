defmodule XmlSchema.Type.Atom do
  @moduledoc """
  Type translates a string into an atom on xml parsing. Use
  with caution, only for trusted documents. Can lead to
  atom exhaustion.
  """

  use Ecto.Type

  def type, do: :atom

  def cast(string) when is_binary(string),
    do: String.to_atom(string)

  def cast(string) when is_list(string),
    do: List.to_atom(string)

  def dump(atm), do: to_string(atm)

  def equal?(a, b), do: a == b

  def load(string), do: String.to_atom(string)
end
