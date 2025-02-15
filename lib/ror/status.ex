defmodule ROR.Status do
  @moduledoc """
  Functions for extracting and using Status data from a ROR Organization record

  An Organization's status is one of three atoms: `:active`, `:inactive` and `:withdrawn`

  By default only `:active` Organizations are returned by the ROR API.
  """

  @doc """
  Extracts the status from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

      iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
      ...> ROR.Status.extract(record)
      :active

  """
  @spec extract(data :: map()) :: atom()
  def extract(data) do
    String.to_atom(data["status"])
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:active, :inactive, :withdrawn]
  end
end
