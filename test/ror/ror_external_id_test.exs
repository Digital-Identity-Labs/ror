defmodule RorExternalIDTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.ExternalID, as: ThisModule

  describe "extract/1" do

    test "returns a list of %ExternalID{} when passed organization data" do
      assert [%ThisModule{} | _] = ThisModule.extract(@example_org_data)
    end

  end

  describe "vocab/0" do

    test "returns an array contains key vocabulary/values, as atoms" do
      assert [:fundref, :grid, :isni, :wikidata] = ThisModule.vocab()
    end

  end

  describe "String.Chars Protocol" do

    test "returns a simple string representation when interpolated or otherwise converted to a string" do
      assert ["100005595", "grid.30389.31", "0000 0001 2348 0690"] = Enum.map(
               ThisModule.extract(@example_org_data),
               &to_string/1
             )
    end

  end

end
