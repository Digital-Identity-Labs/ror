defmodule RorResultsTest do
  use ExUnit.Case

  @example_results_json File.read!("test/support/static/example_results.json")
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
      assert 109_806 = Results.number_of_results(results)
    end
  end

  describe "Enumeration protocol" do
    test "can be counted" do
      results = Results.extract(@example_results_data)
      assert 20 = Enum.count(results)
    end

    test "can respond to member?" do
      results = Results.extract(@example_results_data)
      item = List.first(results.items)
      assert Enum.member?(results, item)
    end

    test "can be sliced" do
      results = Results.extract(@example_results_data)
      assert 4 = Enum.slice(results, 0..3) |> Enum.count()
    end

    test "can be iterated" do
      results = Results.extract(@example_results_data)

      assert [
               "https://ror.org/04ttjf776",
               "https://ror.org/01rxfrp27",
               "https://ror.org/023q4bk22",
               "https://ror.org/006jxzx88",
               "https://ror.org/00wfvh315",
               "https://ror.org/05ktbsm52",
               "https://ror.org/00nx6aa03",
               "https://ror.org/02k3cxs74",
               "https://ror.org/046fa4y88",
               "https://ror.org/02d439m40",
               "https://ror.org/04h08p482",
               "https://ror.org/01zctcs90",
               "https://ror.org/05m7zw681",
               "https://ror.org/03awtex73",
               "https://ror.org/00kv9pj15",
               "https://ror.org/03mjtdk61",
               "https://ror.org/04yyp8h20",
               "https://ror.org/022rkxt86",
               "https://ror.org/01wddqe20",
               "https://ror.org/03kwrfk72"
             ] = Enum.map(results, fn r -> r.id end)
    end
  end
end
