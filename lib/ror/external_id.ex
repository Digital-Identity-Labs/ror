defmodule ROR.ExternalID do

  #@enforce_keys [:id]
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

  @spec vocab() :: list(atom())
  def vocab do
    [:fundref, :grid, :isni, :wikidata]
  end

end
