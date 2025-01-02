defmodule RorNameTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Name, as: ThisModule

  describe "extract/1" do

    test "returns a list of %Name{} structs when passed organization data" do
      assert [%ThisModule{} | _ ] = ThisModule.extract(@example_org_data)
    end

  end

  describe "vocab/0" do

    test "returns an array contains key vocabulary/values, as atoms" do
      assert [:acronym, :alias, :label, :ror_display] = ThisModule.vocab()
    end

  end

end
