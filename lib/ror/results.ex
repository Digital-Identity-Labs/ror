defmodule ROR.Results do
  @moduledoc """
  A structure and tools for search and list results

  This struct supports the `Enum` protocol, so you can directly iterate the Organizations within.

  """

  alias __MODULE__
  alias ROR.Organization
  alias ROR.Results

  @type t :: %__MODULE__{
          results: integer(),
          items: list(Organization.t()),
          time: integer()
        }

  defstruct results: 0,
            items: [],
            time: 0

  @doc """
  Extract a Results struct, containing Organizations, from the JSON returned by the ROR query and list API.

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.
  """
  @spec extract(data :: map()) :: Results.t()
  def extract(data) do
    %Results{
      items: Organization.extract(data),
      results: data["number_of_results"],
      time: data["time_taken"]
    }
  end

  @doc """
  Returns a list of all Organizations in the Results
  """
  @spec organizations(results :: Results.t()) :: list(Organization.t())
  def organizations(%Results{} = results) do
    results.items
  end

  @doc """
  Returns a list of all Organizations in the Results but you're less likely to use an 's' by mistake
  """
  @spec orgs(results :: Results.t()) :: list(Organization.t())
  def orgs(%Results{} = results) do
    results.items
  end

  @doc """
  Returns time taken by query on the API service (ms)
  """
  @spec time_taken(results :: Results.t()) :: integer()
  def time_taken(%Results{} = results) do
    results.time
  end

  @doc """
  Returns **total** number of results (not just the set of up to 20 returned in the current page)
  """
  @spec number_of_results(results :: Results.t()) :: integer()
  def number_of_results(%Results{} = results) do
    results.results
  end
end
