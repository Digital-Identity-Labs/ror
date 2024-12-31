defmodule ROR.Results do

  #@enforce_keys [:id]
  alias __MODULE__
  alias ROR.Organization

  defstruct [
    results: 0,
    items: [],
    time: 0
  ]

  def extract(data) do
    orgs = data
           |> Map.get("items", [])
           |> Enum.map(fn d -> Organization.extract(d) end)

    %Results{
      items: orgs,
      results: data["number_of_results"],
      time: data["time_taken"]
    }

  end

  def organizations(results) do
    results.items
  end

  def orgs(results) do
    results.items
  end

  def time_taken(results) do
    results.time
  end

  def number_of_results(results) do
    results.results
  end

end
