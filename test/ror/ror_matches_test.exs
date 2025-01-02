defmodule RorMatchesTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Matches, as: ThisModule

  describe "extract/1" do

#    test "returns an %Matches{} struct  when passed organization data" do
#      assert %ThisModule{} = ThisModule.extract(@example_org_data)
#    end

  end

  describe "matches/1" do

  end

  describe "number_of_matches/1" do

  end

  describe "chosen/1" do

  end

  describe "chosen_organization/1" do

  end

  describe "Enumeration protocol" do

  end

end
