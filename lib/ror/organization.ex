defmodule ROR.Organization do

  @moduledoc """
  XX
  """

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

  @type t :: %__MODULE__{
               id: binary(),
               admin: Admin.t(),
               domains: list(binary()),
               established: integer(),
               external_ids: list(ExternalID.t()),
               links: list(Link.t()),
               locations: list(Location.t()),
               names: list(Name.t()),
               relationships: list(Relationship.t()),
               status: atom(),
               types: list(atom())
             }


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

  @doc """
  XX
  """
  @spec extract(data :: map()) :: Organization.t() | list(Organization.t())
  def extract(%{"items" => items}) do
    for o <- items do
      extract(o)
    end
  end

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

  @doc """
  XX
  """
  @spec id(org :: Organization.t()) :: binary()
  def id(%Organization{id: id} = _org) do
    ID.minimize(id)
  end

  @doc """
  XX
  """
  @spec full_id(org :: Organization.t()) :: binary()
  def full_id(%Organization{id: id} = _org) do
    id
  end

  @doc """
  XX
  """
  @spec vocab() :: list(atom())
  def vocab do
    []
  end

end
