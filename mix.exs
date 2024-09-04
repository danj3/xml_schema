defmodule XmlSchema.MixProject do
  use Mix.Project

  def project do
    [
      app: :xml_schema,
      version: "2.0.2",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(),
      package: package(),

      # Docs
      name: "XmlSchema",
      source_url: "https://github.com/danj3/xml_schema/tree/v-2.0.1",
      docs: [
        main: "readme",
        extras: [
          "README.md"
        ]
      ]
    ]
  end

  defp package do
    [
      exclude_patterns: [~r{.*~$}],
      description: description(),
      files: [
        "mix.exs",
        "*.md",
        "lib",
        "test/support/example/many.ex",
        "test/support/example/one.ex",
        "test/support/example/one_block.ex",
        "test/support/example/tag.ex",
        "test/support/example/attribute.ex"
      ],
      licenses: ["Apache-2.0"],
      links: %{
        "github" => "https://github.com/danj3/xml_schema"
      }
    ]
  end

  defp description do
    """
    Parse and generate XML using DSL extension of Ecto.Schema.
    """
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
      {:xml_builder, "~> 2.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
