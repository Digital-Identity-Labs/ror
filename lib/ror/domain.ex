defmodule ROR.Domain do

  @moduledoc """
  XX
  """

  @doc """
  XX
  """
  @spec extract(data :: map()) :: list(binary())
  def extract(%{"domains" => missing}) when is_nil(missing) or missing == [] do
    []
  end

  def extract(data) do
    data["domains"]
    |> Enum.map(fn d -> d end)
  end

  @doc """
  XX
  """
  @spec vocab() :: list(atom())
  def vocab do
    []
  end

end
