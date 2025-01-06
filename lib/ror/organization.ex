defmodule ROR.Organization do
  @moduledoc """
  Functions for extracting and using Organization data from a ROR Organization record

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

  defstruct id: nil,
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

  @doc """
  Extracts an Organization struct from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

      iex(12)> ROR.Organization.extract(record)
      %ROR.Organization{
        id: "https://ror.org/00pjdza24",
        admin: %ROR.Admin{
          created_at: ~D[2020-04-25],
          created_schema: "1.0",
          updated_at: ~D[2022-10-18],
          updated_schema: "2.0"
        },
        domains: ["universityofcalifornia.edu"],
        established: 1868,
        external_ids: [
          %ROR.ExternalID{
            type: :fundref,
            preferred: "100005595",
            all: ["100005595", "100009350", "100004802", "100010574", "100005188", "100005192"]
          },
          %ROR.ExternalID{
            type: :grid,
            preferred: "grid.30389.31",
            all: ["grid.30389.31"]
          },
          %ROR.ExternalID{type: :isni, preferred: nil, all: ["0000 0001 2348 0690"]}
        ],
        links: [
          %ROR.Link{type: :website, value: "http://www.universityofcalifornia.edu/"},
          %ROR.Link{
            type: :wikipedia,
            value: "http://en.wikipedia.org/wiki/University_of_California"
          }
        ],
        locations: [
          %ROR.Location{
            type: :geonames,
            id: 5_378_538,
            continent_name: nil,
            continent_code: nil,
            country_code: "US",
            country_name: "United States",
            country_subdivision_code: nil,
            country_subdivision_name: nil,
            latitude: 37.802168,
            longitude: -122.271281,
            name: "Oakland"
          }
        ],
        names: [
          %ROR.Name{lang: "en", types: [:acronym], value: "UC"},
          %ROR.Name{lang: "en", types: [:alias], value: "UC System"},
          %ROR.Name{
            lang: "en",
            types: [:ror_display, :label],
            value: "University of California System"
          },
          %ROR.Name{lang: "fr", types: [:label], value: "Université de Californie"}
        ],
        relationships: [
          %ROR.Relationship{
            id: "https://ror.org/02jbv0t02",
            label: "Lawrence Berkeley National Laboratory",
            type: :related
          },
          %ROR.Relationship{
            id: "https://ror.org/03yrm5c26",
            label: "California Digital Library",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/00zv0wd17",
            label: "Center for Information Technology Research in the Interest of Society",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/03t0t6y08",
            label: "University of California Division of Agriculture and Natural Resources",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/01an7q238",
            label: "University of California, Berkeley",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/05rrcem69",
            label: "University of California, Davis",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/04gyf1771",
            label: "University of California, Irvine",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/046rm7j60",
            label: "University of California, Los Angeles",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/00d9ah105",
            label: "University of California, Merced",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/03nawhv43",
            label: "University of California, Riverside",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/0168r3w48",
            label: "University of California, San Diego",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/043mz5j54",
            label: "University of California, San Francisco",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/02t274463",
            label: "University of California, Santa Barbara",
            type: :child
          },
          %ROR.Relationship{
            id: "https://ror.org/03s65by71",
            label: "University of California, Santa Cruz",
            type: :child
          }
        ],
        status: :active,
        types: [:education]
      }

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
      relationships: Relationship.extract(data)
    }
  end

  @doc """
  Returns the ID from an Organization
  """
  @spec id(org :: Organization.t()) :: binary()
  def id(%Organization{id: id} = _org) do
    ID.minimize(id)
  end

  @doc """
  Returns the full ID from an Organization
  """
  @spec full_id(org :: Organization.t()) :: binary()
  def full_id(%Organization{id: id} = _org) do
    id
  end

  @doc false
  @spec vocab() :: list(atom())
  def vocab do
    []
  end
end
