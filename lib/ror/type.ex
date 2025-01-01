defmodule ROR.Type do

  @moduledoc """
  XX
  """

  @doc """
  XX
  """
  @spec extract(data :: map()) :: list(atom())
  def extract(data) do
    Enum.map(data["types"], fn t -> String.to_atom(t) end)
  end

  @doc """
  XX
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:education, :funder, :healthcare, :company, :archive, :nonprofit, :government, :facility, :other]
  end

end
