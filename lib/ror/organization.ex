defmodule ROR.Organization do

  @enforce_keys [:id]
  alias __MODULE__

  defstruct [
    id: nil,
    admin: %{},
    domains: [],
    established: nil,
    external_ids: [],
    links: [],
    locations: [],
    names: [],
    relationships: [],
    status: nil,
    types: []
  ]

  def extract(data) do
    %Organization{
      id: data["id"],
      established: data["established"],
      status: String.to_atom(data["status"]),
      types: Enum.map(data["types"], fn t -> String.to_atom(t) end)
    }
  end

end
