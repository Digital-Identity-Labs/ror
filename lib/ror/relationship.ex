defmodule ROR.Relationship do

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

  @spec vocab() :: list(atom())
  def vocab do
    [:related, :parent, :child, :predecessor, :successor]
  end

end
