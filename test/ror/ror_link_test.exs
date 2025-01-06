defmodule RorLinkTest do
  use ExUnit.Case

  @example_org_json File.read!("test/support/static/example_org.json")
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Link, as: ThisModule

  describe "extract/1" do
    test "returns a list of %Link{} structs when passed organization data" do
      assert [%ThisModule{} | _] = ThisModule.extract(@example_org_data)
    end

    test "each item contains a type atom" do
      assert [%ThisModule{type: :website}, %ThisModule{type: :wikipedia}] =
               ThisModule.extract(@example_org_data)
    end

    test "each item contains a value string" do
      assert [
               %ThisModule{value: "http://www.universityofcalifornia.edu/"},
               %ThisModule{value: "http://en.wikipedia.org/wiki/University_of_California"}
             ] = ThisModule.extract(@example_org_data)
    end
  end

  describe "vocab/0" do
    test "returns an array contains key vocabulary/values, as atoms" do
      assert [] = ThisModule.vocab()
    end
  end

  describe "String.Chars Protocol" do
    test "returns a simple string representation when interpolated or otherwise converted to a string" do
      assert [
               "http://www.universityofcalifornia.edu/",
               "http://en.wikipedia.org/wiki/University_of_California"
             ] = Enum.map(ThisModule.extract(@example_org_data), &to_string/1)
    end
  end
end
