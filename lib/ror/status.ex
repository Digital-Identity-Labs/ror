defmodule ROR.Status do

  @moduledoc """
  XX
  """

  @doc """
  XX
  """
  @spec extract(data :: map()) :: atom()
  def extract(data) do
    String.to_atom(data["status"])
  end

  @doc """
  XX
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:active, :inactive, :withdrawn]
  end

end


