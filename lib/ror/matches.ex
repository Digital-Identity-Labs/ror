defmodule ROR.Matches do

  #@enforce_keys [:id]
  alias __MODULE__
  alias ROR.Match

  defstruct [
    results: 0,
    items: [],
    time: 0
  ]

  def extract(data) do
    orgs = data
           |> Map.get("items", [])
           |> Enum.map(fn d -> Match.extract(d) end)

    %Matches{
      items: orgs,
      results: data["number_of_results"]
    }

  end

  def matches(matches) do
    matches.items
  end

  def number_of_matches(matches) do
    matches.results
  end

  def chosen(matches) do
    Enum.find(matches.items, fn m -> m.chosen == true end)
  end

  def chosen_organization(matches) do
    chosen = chosen(matches)
    if chosen do
      chosen.organization
    else
      nil
    end
  end

end
