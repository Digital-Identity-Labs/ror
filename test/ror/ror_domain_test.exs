defmodule RorDomainTest do
  use ExUnit.Case

  @example_org_json File.read!("test/support/static/example_org.json")
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Domain, as: ThisModule

  describe "extract/1" do
    test "returns an array of domain strings when passed organization data" do
      assert ["universityofcalifornia.edu"] = ThisModule.extract(@example_org_data)
    end
  end

  describe "vocab/0" do
    test "returns an array contains key vocabulary/values, as atoms" do
      assert [] = ThisModule.vocab()
    end
  end
end
