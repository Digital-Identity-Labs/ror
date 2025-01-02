defmodule RorMatchesTest do
  use ExUnit.Case

  @example_matches_json File.read! "test/support/static/example_matches.json"
  @example_matches_data Jason.decode!(@example_matches_json)

  alias ROR.Matches, as: ThisModule
  alias ROR.Matches
  alias ROR.Match
  alias ROR.Organization

  describe "extract/1" do

    test "returns a %Matches{} struct when passed matches data" do
      assert %Matches{} = ThisModule.extract(@example_matches_data)
    end

  end

  describe "matches/1" do

    test "returns a list of match records when passed a Matches record" do
      matches = Matches.extract(@example_matches_data)
      assert [%Match{} | _] = Matches.matches(matches)
    end

  end

  describe "number_of_matches/1" do

    test "returns the number of matches" do
      matches = Matches.extract(@example_matches_data)
      assert 12 = Matches.number_of_matches(matches)
    end

  end

  describe "chosen/1" do

    test "returns the chosen match, if there is one" do
      matches = Matches.extract(@example_matches_data)
      assert %Match{organization: %Organization{id: "https://ror.org/04h699437"}} = Matches.chosen(matches)
    end

    test "returns nil, if there isn't one" do
      edited_items = List.delete_at(Map.get(@example_matches_data, "items"), 0)
      edited_data = Map.merge(@example_matches_data, %{"items" => edited_items})
      matches = Matches.extract(edited_data)
      assert is_nil(Matches.chosen(matches))
    end

  end

  describe "chosen_organization/1" do

    test "returns the chosen match's Organization struct, if there is one" do
      matches = Matches.extract(@example_matches_data)
      assert %Organization{id: "https://ror.org/04h699437"} = Matches.chosen_organization(matches)
    end

    test "returns nil, if there isn't one" do
      edited_items = List.delete_at(Map.get(@example_matches_data, "items"), 0)
      edited_data = Map.merge(@example_matches_data, %{"items" => edited_items})
      matches = Matches.extract(edited_data)
      assert is_nil(Matches.chosen_organization(matches))
    end

  end

  describe "Enumeration protocol" do

  end

end
