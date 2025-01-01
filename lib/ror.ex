defmodule ROR do

  alias ROR.Client
  alias ROR.Organization
  alias ROR.Params
  alias ROR.Filter
  alias ROR.Results
  alias ROR.Matches

  @spec get!(id :: binary(), opts :: keyword()) ::  map()
  def get!(id, opts \\ []) do
    Client.get!(id, opts)
    |> Organization.extract()
  end

  @spec list!(opts :: keyword()) :: Results.t()
  def list!(opts \\ []) do
    Client.list!(Params.generate(opts))
    |> Results.extract()
  end

  @spec quick_search!(value :: binary(), opts :: keyword()) :: Results.t()
  def quick_search!(search, opts \\ []) do
    Client.query!(Params.query(search), Params.generate(opts))
    |> Results.extract()
  end

  @spec search!(value :: binary(), opts :: keyword()) ::  Results.t()
  def search!(search, opts \\ []) do
    Client.query_advanced!(Params.advanced_query(search), Params.generate(opts))
    |> Results.extract()
  end

  @spec identify!(value :: binary(), opts :: keyword()) :: Matches.t()
  def identify!(search, opts \\ []) do
    Client.affiliation!(Params.query(search), opts)
    |> Matches.extract()
  end

  @spec chosen_organization!(value :: binary(), opts :: keyword()) :: Organization.t() | nil
  def chosen_organization!(search, opts \\ []) do
    Client.affiliation!(Params.query(search), opts)
    |> Matches.extract()
    |> Matches.chosen_organization()
  end

end
