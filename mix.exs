defmodule ChargebeeElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :chargebee_elixir,
      name: "chargebee-elixir",
      description: "Elixir implementation of Chargebee API (WIP)",
      package: %{
        licenses: ["MIT"],
        links: %{
          github: "https://github.com/NicolasMarlier/chargebee-elixir"
        }
      },
      source_url: "https://github.com/NicolasMarlier/chargebee-elixir",
      homepage_url: "https://github.com/NicolasMarlier/chargebee-elixir",
      version: "0.2.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
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
      {:inflex, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.7"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:mox, "~>1.0", only: [:test]},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_check, "~> 0.14.0", only: [:dev], runtime: false}
    ]
  end
end
