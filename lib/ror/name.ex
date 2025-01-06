defmodule ROR.Name do
  @moduledoc """
  Functions for extracting and using Name data from a ROR Organization record

  """

  # @enforce_keys [:id]
  alias __MODULE__

  @type t :: %__MODULE__{
          lang: boolean(),
          types: list(atom()),
          value: binary()
        }

  defstruct lang: nil,
            types: nil,
            value: nil

  @doc """
  Extracts a list of Name structs from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

      iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
      ...> ROR.Name.extract(record)
      [
        %ROR.Name{lang: "en", types: [:acronym], value: "UC"},
        %ROR.Name{lang: "en", types: [:alias], value: "UC System"},
        %ROR.Name{
          lang: "en",
          types: [:ror_display, :label],
          value: "University of California System"
        },
        %ROR.Name{lang: "fr", types: [:label], value: "Université de Californie"}
      ]

  """
  @spec extract(data :: map()) :: list(Name.t())
  def extract(data) do
    for d <- data["names"] do
      %Name{
        lang: d["lang"],
        types: Enum.map(d["types"], fn t -> String.to_atom(t) end),
        value: d["value"]
      }
    end
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:acronym, :alias, :label, :ror_display]
  end
end
