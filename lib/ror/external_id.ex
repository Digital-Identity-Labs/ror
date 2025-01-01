defmodule ROR.ExternalID do

  @moduledoc """
  XX
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
  XX
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
  XX
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:fundref, :grid, :isni, :wikidata]
  end

end
