defmodule RorMatchTest do
  use ExUnit.Case

  @example_matches_json File.read!("test/support/static/example_matches.json")
  @example_matches_data Jason.decode!(@example_matches_json)

  alias ROR.Match, as: ThisModule
  alias ROR.Match

  describe "extract/1" do
    test "returns an array of %Match{} structs when passed matches data" do
      assert [%Match{} | _] = ThisModule.extract(@example_matches_data)
    end
  end

  describe "vocab/0" do
    test "returns an array contains key vocabulary/values, as atoms" do
      assert [:phrase, :common_terms, :fuzzy, :heuristics, :acronym, :exact] = ThisModule.vocab()
    end
  end
end
