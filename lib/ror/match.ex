defmodule ROR.Match do

  @enforce_keys [:organization]
  alias __MODULE__
  alias ROR.Organization

  @type t :: %__MODULE__{
               organization: Organization.t(),
               substring: binary(),
               score: float(),
               chosen: boolean,
               matching_type: atom()
             }


  defstruct [
    organization: nil,
    substring: nil,
    score: 0.0,
    chosen: false,
    matching_type: nil
  ]

  @spec extract(data :: map()) :: list(Match.t())
  def extract(data) do
    for d <- data["items"] do
      %Match{
        organization: Organization.extract(d["organization"]),
        substring: d["substring"],
        score: d["score"],
        chosen: d["chosen"],
        matching_type: mtype_to_atom(d["matching_type"]),
      }
    end
  end

  @spec vocab() :: list(atom())
  def vocab do
    [:phrase, :common_terms, :fuzzy, :heuristics, :acronym, :exact]
  end

  @spec mtype_to_atom(mtype :: binary) :: atom()
  defp mtype_to_atom(mtype) do
    mtype
    |> String.downcase()
    |> String.replace(" ", "_")
    |> String.to_atom()
  end

end
