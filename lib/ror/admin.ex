defmodule ROR.Admin do
  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record

  The admin struct is not the same as the original ROR data: it's flatter, with only one level of fields.
  """

  alias __MODULE__

  @type t :: %__MODULE__{
          created_at: Date.t(),
          created_schema: binary(),
          updated_at: Date.t(),
          updated_schema: binary()
        }

  defstruct created_at: nil,
            created_schema: nil,
            updated_at: nil,
            updated_schema: nil

  @doc """
  Extracts an Admin struct from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

      iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
      ...> ROR.Admin.extract(record)
      %ROR.Admin{
        created_at: ~D[2020-04-25],
        created_schema: "1.0",
        updated_at: ~D[2022-10-18],
        updated_schema: "2.0"
      }

  """
  @spec extract(data :: map()) :: Admin.t()
  def extract(data) do
    %Admin{
      created_at: Date.from_iso8601!(data["admin"]["created"]["date"]),
      created_schema: data["admin"]["created"]["schema_version"],
      updated_at: Date.from_iso8601!(data["admin"]["last_modified"]["date"]),
      updated_schema: data["admin"]["last_modified"]["schema_version"]
    }
  end
end
