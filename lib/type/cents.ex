defmodule XmlSchema.Type.Cents do
  use Ecto.Type

  def type, do: :integer

  def cast( string ) when is_binary( string ),
    do: ( String.to_float( string ) * 100 ) |> trunc

  def cast( string ) when is_list( string ),
    do: cast( to_string( string ) )

  def dump( cents ), do: cents

  def equal?( a, b ), do: a == b

  def load( cents ), do: cents
end
