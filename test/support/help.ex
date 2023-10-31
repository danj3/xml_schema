defmodule Help do
  def do_inspect(parsed) do
    if not is_nil(System.get_env("PRINT")), do: do_inspect_aux(parsed)
  end

  def do_inspect_aux(parts) when is_list(parts) do
    IO.puts([
      "\n",
      Enum.map(parts, fn {k, v} ->
        if is_binary(v) do
          ["  #{k}: \"\"\"\n", v, ~S{"""}, "\n"]
        else
          ["  #{k}: ", inspect(v, pretty: true)]
        end
      end)
    ])
  end

  def do_inspect_aux(parsed) do
    if not is_nil(System.get_env("PRINT")),
      do: IO.puts("\n" <> inspect(parsed, pretty: true))
  end
end
