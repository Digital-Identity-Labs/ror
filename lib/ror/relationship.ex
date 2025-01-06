defmodule ROR.Relationship do
  @moduledoc """
  Functions for extracting and using Relationship data from a ROR Organization record

  """

  # @enforce_keys [:id]
  alias __MODULE__

  @type t :: %__MODULE__{
          id: binary(),
          label: binary(),
          type: atom()
        }

  defstruct id: nil,
            label: nil,
            type: nil

  @doc """
  Extracts a list of Relationship structs from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

      iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
      ...> ROR.Relationship.extract(record)
      [
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
      ]

  """
  @spec extract(data :: map()) :: list(Relationship.t())
  def extract(data) do
    for d <- data["relationships"] do
      %Relationship{
        id: d["id"],
        type: String.to_atom(d["type"]),
        label: d["label"]
      }
    end
  end

  @doc """
  Lists the allowed terms or types for this data structure, as atoms.
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:related, :parent, :child, :predecessor, :successor]
  end
end
