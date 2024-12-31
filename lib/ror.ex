defmodule ROR do

  alias ROR.Client
  alias ROR.Organization
  alias ROR.Params
  alias ROR.Filter
  alias ROR.Results
  alias ROR.Matches

  #@http_opts_schema NimbleOptions.new!([])

  def get!(id, opts \\ []) do
    Client.get!(id, opts)
    |> Organization.extract()
  end

  def list!(opts \\ []) do
    Client.list!(Params.generate(opts))
    |> Results.extract()
  end

  def quick_search!(search, opts \\ []) do
    Client.query!(Params.query(search), Params.generate(opts))
    |> Results.extract()
  end

  def search!(search, opts \\ []) do
    Client.query_advanced!(Params.advanced_query(search), Params.generate(opts))
    |> Results.extract()
  end

  def identify!(search, opts \\ []) do
    Client.affiliation!(Params.query(search), [])
    |> Matches.extract()
  end

  def chose_organization!(search, opts \\ []) do
    Client.affiliation!(Params.query(search), [])
    |> Matches.extract()
    |> Matches.chosen_organization()
  end

end
