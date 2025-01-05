defmodule ROR.ExternalID do

  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record


  """

  alias __MODULE__

  @type t :: %__MODULE__{
               type: atom(),
               preferred: boolean(),
               all: list(binary())
             }


  defstruct [
    type: nil,
    preferred: nil,
    all: []
  ]

  @doc """
  Extracts a XXX struct from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

  iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
  iex> ROR.Admin.extract(record)
  %ROR.XXX{}

  """
  @spec extract(data :: map()) :: list(ExternalID.t())
  def extract(data) do
    for d <- data["external_ids"] do
      %ExternalID{
        type: String.to_atom(d["type"]),
        preferred: d["preferred"],
        all: d["all"]
      }
    end
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:fundref, :grid, :isni, :wikidata]
  end

end
