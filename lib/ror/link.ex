defmodule ROR.Link do

  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record


  """

  #@enforce_keys [:id]
  alias __MODULE__

  @type t :: %__MODULE__{
               type: atom(),
               value: binary(),
             }

  defstruct [
    type: nil,
    value: nil,
  ]

  @doc """
  Extracts a XXX struct from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

  iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
  iex> ROR.Admin.extract(record)
  %ROR.XXX{}

  """
  @spec extract(data :: map()) :: list(Link.t())
  def extract(data) do
    for d <- data["links"] do
      %Link{
        type: String.to_atom(d["type"]),
        value: d["value"],
      }
    end
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    []
  end

end
