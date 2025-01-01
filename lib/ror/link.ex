defmodule ROR.Link do

  @moduledoc """
  XX
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
  XX
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
  XX
  """
  @spec vocab() :: list(atom())
  def vocab do
    []
  end

end
