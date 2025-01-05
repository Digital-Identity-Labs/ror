defmodule ROR.Relationship do

  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record


  """

  #@enforce_keys [:id]
  alias __MODULE__

  @type t :: %__MODULE__{
               id: binary(),
               label: binary(),
               type: atom(),
             }

  defstruct [
    id: nil,
    label: nil,
    type: nil,
  ]

  @doc """
  Extracts a XXX struct from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

  iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
  iex> ROR.Admin.extract(record)
  %ROR.XXX{}

  """
  @spec extract(data :: map()) :: list(Relationship.t())
  def extract(data) do
    for d <- data["relationships"] do
      %Relationship{
        id: d["id"],
        type: String.to_atom(d["type"]),
        label: d["label"],
      }
    end
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:related, :parent, :child, :predecessor, :successor]
  end

end
