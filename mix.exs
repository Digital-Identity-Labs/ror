defmodule Ror.MixProject do
  use Mix.Project

  def project do
    [
      app: :ror,
      version: "0.1.0",
      elixir: "~> 1.16",
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
      {:req, "~> 0.5.0"},
      {:briefly, "~> 0.5.0"},
      {:castore, ">= 1.0.5"},
      {:memoize, "~> 1.4"},
      {:jason, "~> 1.4"},
      {:iteraptor, "~> 1.14"},
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
      {:observer_cli, "~> 1.7"}


    ]
  end
end
