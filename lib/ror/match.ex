defmodule ROR.Match do
  @moduledoc """
  Functions for extracting and using Match data from a ROR Organization record

  Each Organization with a match from the `ROR.identify!/2` function is wrapped up in a Match struct
  """

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

  defstruct organization: nil,
            substring: nil,
            score: 0.0,
            chosen: false,
            matching_type: nil

  @doc """
  Extracts Match records from the JSON returned by an affiliation API call
  """
  @spec extract(data :: map()) :: list(Match.t())
  def extract(data) do
    for d <- data["items"] do
      %Match{
        organization: Organization.extract(d["organization"]),
        substring: d["substring"],
        score: d["score"],
        chosen: d["chosen"],
        matching_type: mtype_to_atom(d["matching_type"])
      }
    end
  end

  @doc """
  List possible types of match
  """
  @spec vocab() :: list(atom())
  def vocab do
    [:phrase, :common_terms, :fuzzy, :heuristics, :acronym, :exact]
  end

  ###############################################################################################################

  @spec mtype_to_atom(mtype :: binary) :: atom()
  defp mtype_to_atom(mtype) do
    mtype
    |> String.downcase()
    |> String.replace(" ", "_")
    |> String.to_atom()
  end
end
