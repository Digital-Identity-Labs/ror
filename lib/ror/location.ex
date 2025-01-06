defmodule ROR.Location do
  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record

  Location structs are a little different to the ROR JSON data - they're flattened, with a type - but contain the same
    information.
  """

  # @enforce_keys [:id]
  alias __MODULE__

  @type t :: %__MODULE__{
          type: atom(),
          id: binary(),
          continent_name: binary(),
          continent_code: binary(),
          country_code: binary(),
          country_name: binary(),
          country_subdivision_code: binary(),
          country_subdivision_name: binary(),
          latitude: float(),
          longitude: float(),
          name: binary()
        }

  defstruct type: :geonames,
            id: nil,
            continent_name: nil,
            continent_code: nil,
            country_code: nil,
            country_name: nil,
            country_subdivision_code: nil,
            country_subdivision_name: nil,
            latitude: nil,
            longitude: nil,
            name: nil

  @doc """
  Extracts a list of Location structs from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

      iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
      ...> ROR.Location.extract(record)
      [
      %ROR.Location{
        type: :geonames,
        id: 5378538,
        continent_name: nil,
        continent_code: nil,
        country_code: "US",
        country_name: "United States",
        country_subdivision_code: nil,
        country_subdivision_name: nil,
        latitude: 37.802168,
        longitude: -122.271281,
        name: "Oakland"
      }
      ]

  """
  @spec extract(data :: map()) :: list(Location.t())
  def extract(data) do
    for d <- data["locations"] do
      details = d["geonames_details"] || %{}

      %Location{
        id: d["geonames_id"],
        continent_name: details["continent_name"],
        continent_code: details["continent_code"],
        country_code: details["country_code"],
        country_name: details["country_name"],
        country_subdivision_name: details["country_subdivision_name"],
        country_subdivision_code: details["country_subdivision_code"],
        latitude: details["lat"],
        longitude: details["lng"],
        name: details["name"]
      }
    end
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:geonames]
  end
end
