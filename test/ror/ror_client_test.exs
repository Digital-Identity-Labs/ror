defmodule RorClientTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Client, as: ThisModule
  alias ROR.Client

  describe "get!/2" do

    test "returns record for an existing organization when passed its full ID" do

    end

    test "returns record for an existing organization when passed its minimal ID" do

    end

    test "returns record for an existing organization as a map" do

    end

    test "raises an exception when the record is missing" do

    end

    test "raises an exception when the ID is invalid" do

    end

  end

  describe "list!/2" do

    test "returns a list of organizations as a map" do

    end

    test "accepts a page option to select a page" do

    end

    test "accepts a filter option to specify a raw filter string" do

    end

  end

  describe "query!/2" do

    test "accepts a simple value to search for" do

    end

    test "returns a list of organizations as a map" do

    end

    test "accepts a page option to select a page" do

    end

    test "accepts a filter option to specify a raw filter string" do

    end

  end

  describe "query_advanced!/2" do

    test "accepts an Elastic Search style value to search for" do

    end

    test "returns a list of organizations as a map" do

    end

    test "accepts a page option to select a page" do

    end

    test "accepts a filter option to specify a raw filter string" do

    end

  end

  describe "affiliation!/2" do

    test "accepts a value to search for" do

    end

    test "returns a list of matches as a map" do

    end

  end

  describe "http_agent_name/0" do

    test "returns the agent string for HTTP connections" do

    end

    test "the agent string contains the library version" do

    end

  end

  describe "http/1" do

    test "returns a Req.Request struct" do
      assert %Req.Request{} = Client.http()
    end

    test "Req.Request struct contains the agent string" do
      assert %Req.Request{
               options: %{
                 user_agent: "Elixir ROR Client" <> _
               }
             } = Client.http()
    end

    test "Req.Request struct has caching set to true by default" do
      assert %Req.Request{
               options: %{
                 cache: true
               }
             } = Client.http()
    end

    test "Req.Request struct raises errors by default" do
      assert %Req.Request{
               options: %{
                 http_errors: :raise
               }
             } = Client.http()
    end

    test "Req.Request struct sets the base URL to the official ROR API v2 endpoint by default" do
      assert %Req.Request{
               options: %{
                 base_url: "https://api.ror.org/v2/organizations"
               }
             } = Client.http()
    end

  end

end
