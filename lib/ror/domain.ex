defmodule ROR.Domain do
  @moduledoc """
  Functions for extracting and using Domain data from a ROR Organization record

  Domains are a list of strings.
  """

  @doc """
  Extracts list of domain name strings from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

  iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
  ...> ROR.Domain.extract(record)
  ["universityofcalifornia.edu"]

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
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    []
  end
end
