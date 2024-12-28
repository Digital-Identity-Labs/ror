defmodule ROR.Link do

  #@enforce_keys [:id]
  alias __MODULE__

  defstruct [
    type: nil,
    value: nil,
  ]

  def extract(data) do
    for d <- data["links"] do
      %Link{
        type: String.to_atom(d["type"]),
        value: d["value"],
      }
    end
  end

end
