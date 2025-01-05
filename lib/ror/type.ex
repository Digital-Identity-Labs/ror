defmodule ROR.Type do

  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record


  """

  @doc """
  Extracts a XXX struct from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

  iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
  iex> ROR.Admin.extract(record)
  %ROR.XXX{}

  """
  @spec extract(data :: map()) :: list(atom())
  def extract(data) do
    Enum.map(data["types"], fn t -> String.to_atom(t) end)
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:education, :funder, :healthcare, :company, :archive, :nonprofit, :government, :facility, :other]
  end

end
