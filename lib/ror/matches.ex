defmodule ROR.Matches do
  @moduledoc """
  A structure for storing organization match results from Identify/Affiliation searches

  Matches is the equivalent to the `ROR.Results` struct when checking for affiliation matches with `ROR.identify!/2`

  This struct supports the `Enum` protocol, so you can directly iterate the matches within
  """

  # @enforce_keys [:id]
  alias __MODULE__
  alias ROR.Match

  @type t :: %__MODULE__{
          results: integer(),
          items: list(ROR.Match.t()),
          time: integer()
        }

  defstruct results: 0,
            items: [],
            time: 0

  @doc """
  Extract a Matches struct, containing Match structs and Organizations, from the JSON returned by the ROR affiliation API.

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.
  """
  @spec extract(data :: map()) :: Matches.t()
  def extract(data) do
    %Matches{
      items: Match.extract(data),
      results: data["number_of_results"]
    }
  end

  @doc """
  Lists Matches
  """
  @spec matches(matches :: Matches.t()) :: list(Match.t())
  def matches(%Matches{} = matches) do
    matches.items
  end

  @doc """
  Returns the total number of matches
  """
  @spec number_of_matches(matches :: Matches.t()) :: integer()
  def number_of_matches(%Matches{} = matches) do
    matches.results
  end

  @doc """
  Returns a chosen Match (a reliably high-rated match) or nil if one has not been found
  """
  @spec chosen(matches :: Matches.t()) :: Match.t() | nil
  def chosen(%Matches{} = matches) do
    Enum.find(matches.items, fn m -> m.chosen == true end)
  end

  @doc """
  Returns a chosen Organization (from within a reliably high-rated match) or nil if one has not been found
  """
  @spec chosen_organization(matches :: Matches.t()) :: nil | ROR.Organization.t()
  def chosen_organization(%Matches{} = matches) do
    chosen = chosen(matches)

    if is_nil(chosen) do
      nil
    else
      chosen.organization
    end
  end
end
