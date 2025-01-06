defmodule Ror.MixProject do
  use Mix.Project

  def project do
    [
      app: :ror,
      version: "0.1.0",
      elixir: "~> 1.16",
      description: "An unofficial API client for the Research Organization Registry (ROR)",
      package: package(),
      name: "ROR",
      source_url: "https://github.com/Digital-Identity-Labs/ror",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      docs: [
        main: "readme",
        logo: "logo.png",
        extras: ["README.md", "LICENSE"]
      ],
      deps: deps(),
      # Needed until issue fixed in Rambo
      compilers: Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env())
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
      {:req, "~> 0.5.0"},
      {:castore, ">= 1.0.5"},
      {:jason, "~> 1.4"},
      {:curl_req, "~> 0.98.0"},
      {:apex, "~> 1.2", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.14 and >= 0.14.4", only: [:dev, :test]},
      {:benchee, "~> 1.3", only: [:dev, :test]},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:earmark, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:doctor, "~> 0.21", only: :dev, runtime: false},
      {:ex_json_schema, "~> 0.10.2", only: :test, runtime: false},
      {:doctest_formatter, "~> 0.3.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Digital-Identity-Labs/ror"
      }
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "priv"]
  defp elixirc_paths(_), do: ["lib", "priv"]
end
