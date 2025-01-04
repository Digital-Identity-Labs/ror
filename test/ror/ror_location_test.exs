defmodule RorLocationTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Location, as: ThisModule

  describe "extract/1" do

    test "returns a list of %Location{} structs when passed organization data" do
      assert [%ThisModule{} | _ ] = ThisModule.extract(@example_org_data)
    end

    test "each item contains a type atom" do
      assert [%ThisModule{type: :geonames}] = ThisModule.extract(@example_org_data)
    end

    test "each item contains a geonames id " do
      assert [%ThisModule{id: 5378538}] = ThisModule.extract(@example_org_data)
    end

    test "each item contains a name " do
      assert [%ThisModule{name: "Oakland"}] = ThisModule.extract(@example_org_data)
    end

    test "each item may contains a country_code" do
      assert [%ThisModule{country_code: "US"}] = ThisModule.extract(@example_org_data)
    end

    test "each item may contains a country_name " do
      assert [%ThisModule{country_name: "United States"}] = ThisModule.extract(@example_org_data)
    end

    test "each item may contains a latitude" do
      assert [%ThisModule{latitude: 37.802168}] = ThisModule.extract(@example_org_data)
    end

    test "each item may contains a  longitude" do
      assert [%ThisModule{longitude: -122.271281}] = ThisModule.extract(@example_org_data)
    end

  end

  describe "vocab/0" do

    test "returns an array contains key vocabulary/values, as atoms" do
      assert [:geonames] = ThisModule.vocab()
    end

  end

  describe "String.Chars Protocol" do

    test "returns a simple string representation when interpolated or otherwise converted to a string" do
      assert ["Oakland"] = Enum.map(ThisModule.extract(@example_org_data), &to_string/1)
    end

  end

end
