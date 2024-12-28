defmodule ROR.Admin do

  alias __MODULE__

  defstruct [
    created_at: nil,
    created_schema: nil,
    updated_at: nil,
    updated_schema: nil,
  ]

  def extract(data) do
    %Admin{
      created_at: Date.from_iso8601!(data["admin"]["created"]["date"]),
      created_schema:  data["admin"]["created"]["schema_version"],
      updated_at:  Date.from_iso8601!(data["admin"]["last_modified"]["date"]),
      updated_schema:  data["admin"]["last_modified"]["schema_version"],
    }
  end

end
