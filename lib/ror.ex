defmodule ROR do

  alias ROR.Client
  alias ROR.Organization
  alias ROR.Params
  alias ROR.Filter

  #@http_opts_schema NimbleOptions.new!([])

  def get!(id, opts \\ []) do
    Client.get!(id, opts)
    |> Organization.extract()
  end

  def list!(opts \\ []) do
    Client.list!(Params.generate(opts))
    |> Map.get("items", [])
    |> Enum.map(fn d -> Organization.extract(d) end)
  end

  def quick_search!(search, opts \\ []) do
    Client.query!(Params.query(search), Params.generate(opts))
    |> Map.get("items", [])
    |> Enum.map(fn d -> Organization.extract(d) end)
  end

  def search!(search, opts \\ []) do
    Client.query_advanced!(Params.advanced_query(search), Params.generate(opts))
    |> Map.get("items", [])
    |> Enum.map(fn d -> Organization.extract(d) end)
  end

  def affiliation!(search, opts \\ []) do
    Client.affiliation!(Params.query(search), [])
    |> Map.get("items", [])
    |> Enum.map(fn d -> Organization.extract(d) end)
  end

end
