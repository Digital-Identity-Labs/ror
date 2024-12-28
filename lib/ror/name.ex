defmodule ROR.Name do

  #@enforce_keys [:id]
  alias __MODULE__

  defstruct [
    lang: nil,
    types: nil,
    value: nil,
  ]

  def extract(data) do
    for d <- data["names"] do
      %Name{
        lang: d["lang"],
        types: Enum.map(d["types"], fn t -> String.to_atom(t) end),
        value: d["value"],
      }
    end
  end

end
