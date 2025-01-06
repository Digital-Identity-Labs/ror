defmodule RorStatusTest do
  use ExUnit.Case

  @example_org_json File.read!("test/support/static/example_org.json")
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Status, as: ThisModule

  describe "extract/1" do
    test "returns a status atom when passed organization data" do
      assert :active = ThisModule.extract(@example_org_data)
    end
  end

  describe "vocab/0" do
    test "returns an array contains key vocabulary/values, as atoms" do
      assert [:active, :inactive, :withdrawn] = ThisModule.vocab()
    end
  end
end
