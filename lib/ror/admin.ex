defmodule ROR.Admin do

  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record


  """

  alias __MODULE__

  @type t :: %__MODULE__{
               created_at: Date.t(),
               created_schema: binary(),
               updated_at: Date.t(),
               updated_schema: binary(),
             }

  defstruct [
    created_at: nil,
    created_schema: nil,
    updated_at: nil,
    updated_schema: nil,
  ]

  @doc """
  Extracts a XXX struct from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

  iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
  iex> ROR.Admin.extract(record)
  %ROR.XXX{}

  """
  @spec extract(data :: map()) :: Admin.t()
  def extract(data) do
    %Admin{
      created_at: Date.from_iso8601!(data["admin"]["created"]["date"]),
      created_schema: data["admin"]["created"]["schema_version"],
      updated_at: Date.from_iso8601!(data["admin"]["last_modified"]["date"]),
      updated_schema: data["admin"]["last_modified"]["schema_version"],
    }
  end

end
