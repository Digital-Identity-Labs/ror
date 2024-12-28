defmodule ROR.Organization do

  @enforce_keys [:id]
  alias __MODULE__
  alias ROR.Admin
  alias ROR.Domain
  alias ROR.ExternalID
  alias ROR.ID
  alias ROR.Link
  alias ROR.Location
  alias ROR.Name
  alias ROR.Relationship
  alias ROR.Type
  alias ROR.Status

  defstruct [
    id: nil,
    admin: %Admin{},
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
      id: ID.extract(data),
      established: data["established"],
      status: Status.extract(data),
      types: Type.extract(data),
      admin: Admin.extract(data),
      domains: Domain.extract(data),
      external_ids: ExternalID.extract(data),
      links: Link.extract(data),
      locations: Location.extract(data),
      names: Name.extract(data),
      relationships: Relationship.extract(data),
    }
  end

end
