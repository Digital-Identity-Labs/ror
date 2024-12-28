defmodule ROR.ExternalID do

  #@enforce_keys [:id]
  alias __MODULE__

  defstruct [
    type: nil,
    preferred: nil,
    all: []
  ]

  def extract(data) do
    for d <- data["external_ids"] do
      %ExternalID{
        type: String.to_atom(d["type"]),
        preferred: d["preferred"],
        all: d["all"]
      }
    end
  end

  def vocab do
    [:fundref, :grid, :isni, :wikidata]
  end

end
