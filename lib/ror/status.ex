defmodule ROR.Status do

  alias __MODULE__

  @spec extract(data :: map()) :: atom()
  def extract(data) do
    String.to_atom(data["status"])
  end

  @spec vocab() :: list(atom())
  def vocab do
    [:active, :inactive, :withdrawn]
  end

end


