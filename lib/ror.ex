defmodule ROR do

  @moduledoc """
  XX
  """

  alias ROR.Client
  alias ROR.Organization
  alias ROR.Params
  alias ROR.Results
  alias ROR.Matches

  @doc """
  XX
  """
  @spec get!(id :: binary(), opts :: keyword()) ::  map()
  def get!(id, opts \\ []) do
    Client.get!(id, opts)
    |> Organization.extract()
  end

  @doc """
  XX
  """
  @spec list!(opts :: keyword()) :: Results.t()
  def list!(opts \\ []) do
    Client.list!(params: Params.generate(opts))
    |> Results.extract()
  end

  @doc """
  XX
  """
  @spec quick_search!(value :: binary(), opts :: keyword()) :: Results.t()
  def quick_search!(search, opts \\ []) do
    Client.query!(Params.query(search), params: Params.generate(opts))
    |> Results.extract()
  end

  @doc """
  XX
  """
  @spec search!(value :: binary(), opts :: keyword()) ::  Results.t()
  def search!(search, opts \\ []) do
    Client.query_advanced!(Params.advanced_query(search), params: Params.generate(opts))
    |> Results.extract()
  end

  @doc """
  XX
  """
  @spec identify!(value :: binary(), opts :: keyword()) :: Matches.t()
  def identify!(search, opts \\ []) do

    if opts[:filter], do: raise "Cannot pass a filter to this API function"
    if opts[:page], do: raise "Cannot pass a page to this API function"

    Client.affiliation!(Params.query(search), opts)
    |> Matches.extract()
  end

  @doc """
  XX
  """
  @spec chosen_organization!(value :: binary(), opts :: keyword()) :: Organization.t() | nil
  def chosen_organization!(search, opts \\ []) do
    identify!(search, opts)
    |> Matches.chosen_organization()
  end

end
