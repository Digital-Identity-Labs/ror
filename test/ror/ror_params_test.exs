defmodule RorParamsTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Params, as: ThisModule
  alias ROR.Params
  alias ROR.Filter

  describe "generate/1" do

    test "returns an entire set of normal params for get, query, etc as a keyword list, from options" do
      assert [{:filter, "types:funder"}, {:page, "3"}] = Params.generate(page: 3, filter: [types: "funder"])
    end

    test "returns an empty keyword list if not passed any options" do
      assert [] = Params.generate([])
    end

    test "includes page if one is defined" do
      assert [{:page, "5"}] = Params.generate(page: 5)
    end

    test "does not include page if one is not defined" do
      assert [{:filter, "types:healthcare"}] = Params.generate(filter: [types: "healthcare"])
    end

    test "includes filter if one is defined" do
      assert [{:filter, "types:healthcare"}] = Params.generate(filter: [types: "healthcare"])
    end

    test "does not include filter if one is not defined" do
      assert [{:page, "2"}] = Params.generate(page: 2)
    end

    test "includes all_status only if defined" do
      assert [{all_status, true}] = Params.generate(all_status: true)
    end

  end

  describe "query/1" do

    test "returns an escaped simple query string" do
      assert "This \\&& That" = Params.query("This && That")
    end

    test "URI encoding is not done at this stage, Req handles that" do
      assert "Bath College" = Params.query("Bath College")
    end

  end

  describe "advanced_query/1" do

    test "returns an escaped Elastic Search style query string" do
      assert "This \\&& That" = Params.advanced_query("This && That")
    end

    test "URI encoding is not done at this stage, Req handles that" do
      assert "Bath College" = Params.advanced_query("Bath College")
    end

  end

  describe "page/1" do

    test "returns a page number as a string if one has been specified with the page option" do
      assert "1" = Params.page("1")
    end

    test "returns a page number as a string if one has been specified with the page option (but as an integer)" do
      assert "1" = Params.page(1)
    end

    test "returns nil if one has been specified with the page option" do
      assert is_nil(Params.page(nil))
    end

    test "returns nil if a zero has been specified with the page option" do
      assert is_nil(Params.page(0))
    end

    test "can extract the page from an atomic map or struct" do
      assert "6" = Params.page(%{page: "6"})
    end

  end

end
