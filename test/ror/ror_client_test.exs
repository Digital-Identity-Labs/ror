defmodule RorClientTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  @full_id "https://ror.org/015w2mp89"
  @partial_id "ror.org/015w2mp89"
  @min_id "015w2mp89"
  @missing_id "015w2mp90"
  @invalid_id "xxxxxxxxxxxxxx"

  alias ROR.Client, as: ThisModule
  alias ROR.Client

  describe "get!/2" do

    test "returns record for an existing organization when passed its full ID" do
      assert %{"id" => "https://ror.org/015w2mp89"} = Client.get!(@full_id)
    end

    test "returns record for an existing organization when passed its partial ID" do
      assert %{"id" => "https://ror.org/015w2mp89"} = Client.get!(@partial_id)
    end

    test "returns record for an existing organization when passed its minimal ID" do
      assert %{"id" => "https://ror.org/015w2mp89"} = Client.get!(@min_id)
    end

    test "returns record for an existing organization as a map" do
      assert is_map(Client.get!(@min_id))
    end

    test "raises an exception when the record is missing" do
      assert_raise RuntimeError, fn -> Client.get!(@missing_id) end
    end

    test "raises an exception when the ID is invalid" do
      assert_raise RuntimeError, fn -> Client.get!(@invalid_id) end
    end

  end

  describe "list!/2" do

    test "returns a list of organizations under key 'items' in a map" do
      assert is_map(Client.list!())
      assert %{"id" => _} = Client.list!()
                            |> Map.get("items")
                            |> List.first()
    end

    test "accepts a page option in params to select a page" do
      normal_first_id = Client.list!(
                          params: [
                            page: 1
                          ]
                        )
                        |> Map.get("items")
                        |> List.first()
                        |> Map.get("id")

      with_page_id = Client.list!(
                       params: [
                         page: 2
                       ]
                     )
                     |> Map.get("items")
                     |> List.first()
                     |> Map.get("id")

      refute normal_first_id == with_page_id
    end

    test "accepts a filter option in params to specify a raw filter string" do
      assert %{"status" => "inactive"} = Client.list!(
                                           params: [
                                             filter: "status:inactive"
                                           ]
                                         )
                                         |> Map.get("items")
                                         |> List.first()
    end

  end

  describe "query!/2" do

    test "accepts a simple value to search for and returns a list of organizations and extra info as a map" do
      assert %{"items" => [%{"id" => "https://ror.org/00dn4t376"}]} = Client.query!("Brunel")
    end

    test "returns a list of organizations under key 'items' in a map" do
      assert is_map(Client.query!("Manchester"))
      assert %{"id" => _} = Client.list!()
                            |> Map.get("items")
                            |> List.first()
    end

    test "accepts a page option in params to select a page" do
      normal_first_id = Client.query!(
                          "Manchester",
                          params: [
                            page: 1
                          ]
                        )
                        |> Map.get("items")
                        |> List.first()
                        |> Map.get("id")

      with_page_id = Client.query!(
                       "Manchester",
                       params: [
                         page: 2
                       ]
                     )
                     |> Map.get("items")
                     |> List.first()
                     |> Map.get("id")

      refute normal_first_id == with_page_id
    end

    test "accepts a filter option in params to specify a raw filter string" do
      assert %{"status" => "inactive"} = Client.query!(
                                           "Oxford",
                                           params: [
                                             filter: "status:inactive"
                                           ]
                                         )
                                         |> Map.get("items")
                                         |> List.first()
    end

  end

  describe "query_advanced!/2" do

    test "accepts an Elastic Search style value to search for and returns a map of results and metadata" do
      assert %{"items" => [%{"id" => "https://ror.org/013zder45"}]} = Client.query_advanced!(
               "links.value:\"vcrlter.virginia.edu\""
             )
      assert %{"id" => "https://ror.org/05bnh6r87"} = Client.query_advanced!(
                                                        "names.value:Cornell AND locations.geonames_details.name:Ithaca"
                                                      )
                                                      |> Map.get("items")
                                                      |> List.first()
    end

    test "accepts a page option in params to select a page" do
      normal_first_id = Client.query_advanced!(
                          "names.value:Oxford",
                          params: [
                            page: 1
                          ]
                        )
                        |> Map.get("items")
                        |> List.first()
                        |> Map.get("id")

      with_page_id = Client.query_advanced!(
                       "names.value:Oxford",
                       params: [
                         page: 2
                       ]
                     )
                     |> Map.get("items")
                     |> List.first()
                     |> Map.get("id")

      refute normal_first_id == with_page_id
    end

    test "accepts a filter option in params to specify a raw filter string" do
      assert %{"status" => "inactive"} = Client.query_advanced!(
                                           "names.value:Oxford",
                                           params: [
                                             filter: "status:inactive"
                                           ]
                                         )
                                         |> Map.get("items")
                                         |> List.first()
    end

  end

  describe "affiliation!/2" do

    test "accepts a value to search for and returns a map contain match information" do
      assert %{
               "items" => [
                 %{
                   "chosen" => true,
                   "matching_type" => "EXACT",
                   "organization" => %{
                     "id" => "https://ror.org/04h699437"
                   }
                 } | _
               ]
             } = Client.affiliation!("University of Leicester")
    end

    test "raises an exception if a page param is passed" do
      assert_raise RuntimeError, fn -> Client.affiliation!("University of Leicester", params: [page: 2]) end
    end

    test "raises an exception if a filter param is passed" do
      assert_raise RuntimeError, fn -> Client.affiliation!("University of Leicester", params: [filter: "status:inactive"]) end
    end

  end

  describe "http_agent_name/0" do

    test "returns the agent string for HTTP connections" do
      assert String.contains?(Client.http_agent_name(), "Elixir ROR Client")
    end

    test "the agent string contains the library version" do
      assert String.contains?(Client.http_agent_name(), "#{Application.spec(:ror, :vsn)}")
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

    test "Req.Request struct sets the base URL to the value in :base_url" do
      assert %Req.Request{
               options: %{
                 base_url: "https://api.ror.org/v2/organizations2"
               }
             } = Client.http(http: [base_url: "https://api.ror.org/v2/organizations2"])
    end

  end

  describe "base_url/1" do

    test "if opts includes an :api_url value, then return that" do
      assert "https://example.com/api/" = Client.base_url([api_url: "https://example.com/api/"])
    end

    test "if :api_url has not been set, and the :http opts already contain the :base_url, use that as expected" do
      assert "https://example.com/api2/" = Client.base_url([http: [base_url: "https://example.com/api2/"]])
      assert "https://api.ror.org/v2/organizations" = Client.base_url([http: [base_url: "https://api.ror.org/v2/organizations"]])
    end

    test "if something weird has happened and the :http opts lack a :base_url, use the hardcoded default one" do
      assert "https://api.ror.org/v2/organizations" = Client.base_url([])
    end

  end

end
