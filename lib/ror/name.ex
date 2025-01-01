defmodule ROR.Name do

  #@enforce_keys [:id]
  alias __MODULE__

  @type t :: %__MODULE__{
               lang: boolean(),
               types: list(atom()),
               value: binary(),
             }


  defstruct [
    lang: nil,
    types: nil,
    value: nil,
  ]

  @spec extract(data :: map()) :: list(Name.t())
  def extract(data) do
    for d <- data["names"] do
      %Name{
        lang: d["lang"],
        types: Enum.map(d["types"], fn t -> String.to_atom(t) end),
        value: d["value"],
      }
    end
  end

  @spec vocab() :: list(atom())
  def vocab do
    [:acronym, :alias, :label, :ror_display]
  end

end
