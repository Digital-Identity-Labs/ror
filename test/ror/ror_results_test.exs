defmodule RorResultsTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Results, as: ThisModule

  describe "extract/1" do

#    test "returns an %Results{} struct  when passed organization data" do
#      assert %ThisModule{} = ThisModule.extract(@example_org_data)
#    end

  end

  describe "organizations/1" do

  end

  describe "orgs/1" do

  end

  describe "time_taken/1" do

  end

  describe "number_of_results/1" do

  end

  describe "Enumeration protocol" do

  end


end
