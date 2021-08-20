defmodule XmlSchema do
  @moduledoc """
  Documentation for `XmlSchema`.
  """
  defmacro xml( block ) do
    quote do
      @primary_key false

      embedded_schema do
        field :_attributes, :map
        unquote( block )
      end
    end
  end

  defmacro xml_tag( name, type, opts \\ [] ) do
    Module.put_attribute( __CALLER__.module, :tag_order, name )

    quote do
      field unquote( name ), unquote( type ), unquote( opts )
    end
  end

  defmacro xml_one( name, schema, opts \\ [] )

  defmacro xml_one( name, schema, do: block ) do
    Module.put_attribute( __CALLER__.module, :tag_order, name )

    block =
      quote do
        use XmlSchema

        xml do
          unquote( block )
        end
      end

    new_name = Macro.expand( schema, __CALLER__ )
    module = Module.concat( __CALLER__.module, new_name )
    Module.create( module, block, __CALLER__ )

    quote do
      embeds_one( unquote( name ), unquote( module ), [] )
    end
  end

  defmacro xml_one( name, schema, opts ) do
    Module.put_attribute( __CALLER__.module, :tag_order, name )

    quote do
      embeds_one( unquote( name ), unquote( schema ), unquote( opts ) )
    end
  end

  defmacro xml_many( name, schema, opts \\ [] )

  defmacro xml_many( name, schema, do: block ) do
    Module.put_attribute( __CALLER__.module, :tag_order, name )

    block =
      quote do
        use XmlSchema

        xml do
          unquote( block )
        end
      end

    new_name = Macro.expand( schema, __CALLER__ )
    module = Module.concat( __CALLER__.module, new_name )
    Module.create( module, block, __CALLER__ )

    quote do
      embeds_many( unquote( name ), unquote( module ), [] )
    end
  end

  defmacro xml_many( name, schema, opts ) do
    Module.put_attribute( __CALLER__.module, :tag_order, name )

    quote do
      embeds_many( unquote( name ), unquote( schema ), unquote( opts ) )
    end
  end

  def parse_xml( xml_string, module ) do
    :erlsom.simple_form( xml_string )
    |> case do
      { :ok, sxml, _extra } ->
        unpack_xml( sxml, module )

      other ->
        other
    end
  end

  defp unpack_xml( { _tag, attr, children }, module ) do
    Enum.reduce( children, module.__struct__, &unpack_tag( &1, module, &2 ) )
    |> add_attrs( attr )
  end

  defp add_attrs( ms, [] ), do: ms

  defp add_attrs( ms, attr ) do
    %{ 
      ms
      | :_attributes => Map.new( attr, fn { k, v } -> { to_string( k ), to_string( v ) } end )
    }
  end

  defp unpack_tag( { tag, attr, child }, module, acc ) do
    field = List.to_atom( tag )

    # IO.inspect( {
    #   field,
    #   module,
    #   module.__schema__(:embed,field)
    #     }, label: "embed!" )

    module.__schema__( :type, field )
    #    |> IO.inspect( label: "TYPE")
    |> case do
      nil ->
        try_transform( { tag, attr, child }, module, acc )

      { :array, subtype } ->
        update_array( acc, field, charlist_to_type( child, subtype ) )

      { :parameterized, Ecto.Embedded, params } ->
        embed( acc, field, { tag, attr, child }, params )

      subtype ->
        Map.put( acc, field, charlist_to_type( child, subtype ) )
    end
  end

  defp try_transform( { tag, attr, child }, module, acc ) do
    module.transform( tag )
    |> case do
      nil ->
        acc

      ^tag ->
        acc

      new_tag ->
        unpack_tag( { new_tag, [ {'_tag', tag} | attr ], child }, module, acc )
    end
  end

  defp embed( base, field, val, %{ cardinality: :one } = params ) do
    Map.put( base, field, unpack_xml( val, params.related ) )
  end

  defp embed( base, field, val, %{ cardinality: :many } = params ) do
    cur = Map.get( base, field, [] )
    cur = cur ++ [ unpack_xml(val, params.related) ]
    Map.put( base, field, cur )
  end

  defp update_array( base, field, val ) do
    Map.get( base, field )
    |> case do
      nil ->
        Map.put( base, field, [ val ] )

      list ->
        Map.put( base, field, list ++ [ val ] )
    end
  end

  def charlist_to_type( [], _type ), do: nil

  def charlist_to_type( [ cl ], type ) do
    # IO.puts( "charlist_to_type: val=#{inspect(cl)} type=#{type}")

    cond do
      is_atom( type ) and
        Code.ensure_compiled( type ) == { :module, type } and
          function_exported?( type, :type, 0 ) ->
        type.cast( cl )

      true ->
        case type do
          :atom ->
            { :ok, List.to_atom( cl ) }

          :string ->
            { :ok, List.to_string( cl ) }

          :boolean ->
            Ecto.Type.cast( :boolean, List.to_string( cl ) |> String.downcase() )

          prim ->
            Ecto.Type.cast( prim, List.to_string( cl ) )
        end
        |> case do
          { :ok, val } -> val
          other -> other
        end
    end
  end

  def generate_child( schema, as_tag ) do
    attr = Map.get( schema, :_attributes ) || []

    children =
      schema.__struct__.xml_tag_list()
      |> Enum.reverse()
      |> Enum.reduce( [], fn
        :_attributes, acc ->
          acc

        fld, acc ->
          fld_c = to_charlist( fld )

          Map.get( schema, fld )
          |> case do
            nil ->
              acc

            val ->
              schema.__struct__.__schema__( :type, fld )
              |> case do
                { :parameterized, Ecto.Embedded, %{ cardinality: :one } } ->
                  [ generate_child(val, fld_c) | acc ]

                { :parameterized, Ecto.Embedded, %{ cardinality: :many } } ->
                  [ Enum.map(val, &generate_child(&1, fld_c)) | acc ]

                maybe_custom ->
                  cond do
                    Ecto.Type.base?( maybe_custom ) ->
                      [ {fld_c, [], val} | acc ]

                    is_atom( maybe_custom ) and
                      Code.ensure_compiled( maybe_custom ) == { :module, maybe_custom } and
                        function_exported?( maybe_custom, :dump, 1 ) ->
                      [ {fld_c, [], maybe_custom.dump(val)} | acc ]

                    true ->
                      acc
                  end
              end
          end
      end )

    { as_tag, attr, children }
  end

  def generate_xml( schema ) do
    name = schema.__struct__.xml_tag()

    generate_child( schema, name )
    |> XmlBuilder.document()
    |> XmlBuilder.generate( pretty: true )
  end

  def module_tail_to_string( module ) do
    [ name | _ ] = Module.split( module ) |> Enum.reverse()
    name
  end

  defmacro __using__( opts ) do
    xml_name = Keyword.get( opts, :tag, module_tail_to_string( __CALLER__.module ) )

    Module.register_attribute( __CALLER__.module, :tag_order, accumulate: true )

    quote do
      use Ecto.Schema
      import unquote( __MODULE__ )

      def parse_xml( xml_string ) do
        unquote( __MODULE__ ).parse_xml( xml_string, __MODULE__ )
      end

      def xml_tag, do: unquote( xml_name )

      def xml_tag_list, do: Enum.reverse( @tag_order )

      def transform( _tag ), do: nil
      defoverridable transform: 1
    end
  end
end
