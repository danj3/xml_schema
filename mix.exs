defmodule XmlSchema.MixProject do
  use Mix.Project

  def project do
    [
      app: :xml_schema,
      version: "1.1.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths()
    ]
  end

  defp elixirc_paths do
    case Mix.env() do
      :test ->
        ["lib", "test/support"]

      _ ->
        ["lib"]
    end
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto, "~> 3.10"},
      {:erlsom, "~> 1.5"},
      {:xml_builder, "~> 2.2"}
    ]
  end
end
