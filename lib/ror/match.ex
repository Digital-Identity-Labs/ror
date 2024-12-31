defmodule ROR.Match do

  @enforce_keys [:organization]
  alias __MODULE__
  alias ROR.Organization

  defstruct [
    organization: nil,
    substring: nil,
    score: nil,
    chosen: nil,
    matching_type: nil
  ]

  def extract(data) do
    %Match{
      organization: Organization.extract(data["organization"]),
      substring: data["substring"],
      score: data["score"],
      chosen: data["chosen"],
      matching_type: mtype_to_atom(data["matching_type"]),
    }
  end

  def vocab do
    [:phrase, :common_terms, :fuzzy, :heuristics, :acronym, :exact]
  end

  defp mtype_to_atom(mtype) do
    mtype
    |> String.downcase()
    |> String.replace(" ", "_")
    |> String.to_atom()
  end

end
