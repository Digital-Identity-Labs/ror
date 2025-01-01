defmodule ROR.Results do

  alias __MODULE__
  alias ROR.Organization
  alias ROR.Results

  @type t :: %__MODULE__{
               results: integer(),
               items: list(Organization.t()),
               time: integer()
             }

  defstruct [
    results: 0,
    items: [],
    time: 0
  ]

  @spec extract(data :: map()) :: Results.t()
  def extract(data) do
    %Results{
      items: Organization.extract(data),
      results: data["number_of_results"],
      time: data["time_taken"]
    }
  end

  @spec organizations(results :: Results.t()) :: list(Organization.t())
  def organizations(%Results{} = results) do
    results.items
  end

  @spec orgs(results :: Results.t()) :: list(Organization.t())
  def orgs(%Results{} = results) do
    results.items
  end

  @spec time_taken(results :: Results.t()) :: integer()
  def time_taken(%Results{} = results) do
    results.time
  end

  @spec number_of_results(results :: Results.t()) :: integer()
  def number_of_results(%Results{} = results) do
    results.results
  end

end
