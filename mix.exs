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
      {:curl_req, "~> 0.98.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
