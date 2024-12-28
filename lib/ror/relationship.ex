defmodule ROR.Relationship do

  #@enforce_keys [:id]
  alias __MODULE__

  defstruct [
    id: nil,
    label: nil,
    type: nil,
  ]


  def extract(data) do
    for d <- data["relationships"] do
      %Relationship{
        id: d["id"],
        type: String.to_atom(d["type"]),
        label: d["label"],
      }
    end
  end

end
