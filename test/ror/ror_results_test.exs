defmodule RorResultsTest do
  use ExUnit.Case

  @example_results_json File.read! "test/support/static/example_results.json"
  @example_results_data Jason.decode!(@example_results_json)

  alias ROR.Results, as: ThisModule
  alias ROR.Results
  alias ROR.Organization

  describe "extract/1" do

    test "returns an array of %Match{} structs when passed matches data" do
      assert %Results{} = ThisModule.extract(@example_results_data)
    end

  end

  describe "organizations/1" do

    test "returns a list of Organization records when passed a Results record" do
      results = Results.extract(@example_results_data)
      assert [%Organization{} | _] = Results.organizations(results)
    end

  end

  describe "orgs/1" do
    test "returns a list of Organization records when passed a Results record" do
      results = Results.extract(@example_results_data)
      assert [%Organization{} | _] = Results.orgs(results)
    end
  end

  describe "time_taken/1" do

    test "returns the time taken" do
      results = Results.extract(@example_results_data)
      assert is_integer(Results.time_taken(results))
    end

  end

  describe "number_of_results/1" do
    test "returns the time taken" do
      results = Results.extract(@example_results_data)
      assert 109806 = Results.number_of_results(results)
    end
  end

  describe "Enumeration protocol" do

  end


end
