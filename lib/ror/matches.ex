defmodule ROR.Matches do

  #@enforce_keys [:id]
  alias __MODULE__
  alias ROR.Match

  @type t :: %__MODULE__{
               results: integer(),
               items: list(ROR.Match.t()),
               time: integer()
             }


  defstruct [
    results: 0,
    items: [],
    time: 0
  ]

  @spec extract(data :: map()) :: Matches.t()
  def extract(data) do
    %Matches{
      items: Match.extract(data),
      results: data["number_of_results"]
    }
  end

  @spec matches(matches :: Matches.t()) :: list(Match.t())
  def matches(%Matches{} = matches) do
    matches.items
  end

  @spec number_of_matches(matches :: Matches.t()) :: integer()
  def number_of_matches(%Matches{} = matches) do
    matches.results
  end

  @spec chosen(matches :: Matches.t()) :: Match.t() | nil
  def chosen(%Matches{} = matches) do
    Enum.find(matches.items, fn m -> m.chosen == true end)
  end

  @spec chosen_organization(matches :: Matches.t()) :: nil | ROR.Organization.t()
  def chosen_organization(%Matches{} = matches) do
    chosen = chosen(matches)
    if ! is_nil(chosen) do
      chosen.organization
    else
      nil
    end
  end

end
