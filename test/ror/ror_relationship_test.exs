defmodule RorRelationshipTest do
  use ExUnit.Case

  @example_org_json File.read!("test/support/static/example_org.json")
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Relationship, as: ThisModule

  describe "extract/1" do
    test "returns a list of %Relationship{} structs when passed organization data" do
      assert [%ThisModule{} | _] = ThisModule.extract(@example_org_data)
    end

    test "each item contains a ROR ID" do
      assert [%ThisModule{id: "https://ror.org/02jbv0t02"} | _] =
               ThisModule.extract(@example_org_data)
    end

    test "each item contains a label" do
      assert [%ThisModule{label: "Lawrence Berkeley National Laboratory"} | _] =
               ThisModule.extract(@example_org_data)
    end

    test "each item contains a type" do
      assert [%ThisModule{type: :related} | _] = ThisModule.extract(@example_org_data)
    end
  end

  describe "vocab/0" do
    test "returns an array contains key vocabulary/values, as atoms" do
      assert [:related, :parent, :child, :predecessor, :successor] = ThisModule.vocab()
    end
  end

  describe "String.Chars Protocol" do
    test "returns a simple string representation when interpolated or otherwise converted to a string" do
      assert [
               "https://ror.org/02jbv0t02",
               "https://ror.org/03yrm5c26",
               "https://ror.org/00zv0wd17",
               "https://ror.org/03t0t6y08",
               "https://ror.org/01an7q238",
               "https://ror.org/05rrcem69",
               "https://ror.org/04gyf1771",
               "https://ror.org/046rm7j60",
               "https://ror.org/00d9ah105",
               "https://ror.org/03nawhv43",
               "https://ror.org/0168r3w48",
               "https://ror.org/043mz5j54",
               "https://ror.org/02t274463",
               "https://ror.org/03s65by71"
             ] = Enum.map(ThisModule.extract(@example_org_data), &to_string/1)
    end
  end
end
