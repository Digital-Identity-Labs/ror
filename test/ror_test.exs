defmodule RorTest do
  use ExUnit.Case
  doctest ROR

  alias ROR, as: ThisModule
  alias ROR
  alias ROR.Organization
  alias ROR.Results
  alias ROR.Matches
  alias ROR.Match
  alias ROR.Filter

  @full_id "https://ror.org/015w2mp89"
  @partial_id "ror.org/015w2mp89"
  @min_id "015w2mp89"
  @missing_id "015w2mp90"
  @invalid_id "xxxxxxxxxxxxxx"


  describe "get!/2" do

    test "returns Organization struct for an existing organization when passed its full ID" do
      assert %Organization{id: "https://ror.org/015w2mp89"} = ROR.get!(@full_id)
    end

    test "returns Organization struct for an existing organization when passed its partial ID" do
      assert %Organization{id: "https://ror.org/015w2mp89"} = ROR.get!(@partial_id)
    end

    test "returns Organization struct for an existing organization when passed its minimal ID" do
      assert %Organization{id: "https://ror.org/015w2mp89"} = ROR.get!(@min_id)
    end

    test "raises an exception when the record is missing" do
      assert_raise RuntimeError, fn -> ROR.get!(@missing_id) end
    end

    test "raises an exception when the ID is invalid" do
      assert_raise RuntimeError, fn -> ROR.get!(@invalid_id) end
    end

    test "will accept client_id string in opts and add an authentication header" do
      assert %Organization{} = ROR.get!(@min_id, client_id: "testing")
      ## TODO: This is not a useful test really
    end

  end

  describe "list!/2" do

    test "returns a Results struct" do
      assert %Results{} = ROR.list!()
    end

    test "Organizations are available at the :items field/key" do
      assert %Organization{id: _} = ROR.list!()
                                    |> Map.get(:items)
                                    |> List.first()
    end

    test "accepts a page option to select a page" do
      normal_first_id = ROR.list!(page: 1)
                        |> Map.get(:items)
                        |> List.first()
                        |> Map.get(:id)

      with_page_id = ROR.list!(page: 2)
                     |> Map.get(:items)
                     |> List.first()
                     |> Map.get(:id)

      refute normal_first_id == with_page_id
    end

    test "accepts a filter option list " do
      assert %Organization{status: :inactive} = ROR.list!(
                                                  filter: [
                                                    status: :inactive
                                                  ]
                                                )
                                                |> Map.get(:items)
                                                |> List.first()
    end

    test "accepts a Filter struct" do
      assert %Organization{status: :inactive} = ROR.list!(
                                                  filter: Filter.new(status: :inactive)
                                                )
                                                |> Map.get(:items)
                                                |> List.first()
    end

    test "will accept client_id string in opts and add an authentication header" do
      assert %Organization{} = ROR.list!(client_id: "testing")
                               |> Map.get(:items)
                               |> List.first()
      ## TODO: This is not a useful test really
    end

  end

  describe "quick_search!/2" do

    test "accepts a simple value to search for and returns a Results struct" do
      assert %Results{items: [%Organization{id: "https://ror.org/00dn4t376"}]} = ROR.quick_search!("Brunel")
    end

    test "returns a list of organizations under key 'items' in a map" do
      assert %Organization{id: _} = ROR.quick_search!("Manchester")
                                    |> Map.get(:items)
                                    |> List.first()
    end

    test "raises an exception if no search value is passed" do
      assert_raise RuntimeError, fn -> ROR.quick_search!([page: 3]) end
      assert_raise RuntimeError, fn -> ROR.quick_search!("") end
      assert_raise RuntimeError, fn -> ROR.quick_search!(nil) end
    end

    test "accepts a page option to select a page" do
      normal_first_id = ROR.quick_search!("Oxford", page: 1)
                        |> Map.get(:items)
                        |> List.first()
                        |> Map.get(:id)

      with_page_id = ROR.quick_search!("Oxford", page: 2)
                     |> Map.get(:items)
                     |> List.first()
                     |> Map.get(:id)

      refute normal_first_id == with_page_id
    end

    test "accepts a filter option list " do
      assert %Organization{status: :inactive} = ROR.quick_search!(
                                                  "Oxford",
                                                  filter: [
                                                    status: :inactive
                                                  ]
                                                )
                                                |> Map.get(:items)
                                                |> List.first()
    end

    test "accepts a Filter struct" do
      assert %Organization{status: :inactive} = ROR.quick_search!(
                                                  "Oxford",
                                                  filter: Filter.new(status: :inactive)
                                                )
                                                |> Map.get(:items)
                                                |> List.first()
    end

    test "will accept client_id string in opts and add an authentication header" do
      assert %Organization{} = ROR.quick_search!("Oxford", client_id: "testing")
                               |> Map.get(:items)
                               |> List.first()
      ## TODO: This is not a useful test really
    end

  end

  describe "search!/2" do

    test "accepts an Elastic Search style value to search for and returns Results struct" do
      assert %Results{items: [%Organization{id: "https://ror.org/013zder45"} | _]} = ROR.search!(
               "links.value:vcrlter.virginia.edu"
             )

      assert %Organization{id: "https://ror.org/05bnh6r87"} = ROR.search!(
                                                                "names.value:Cornell AND locations.geonames_details.name:Ithaca"
                                                              )
                                                              |> Map.get(:items)
                                                              |> List.first()
    end

    test "accepts a page option to select a page" do
      normal_first_id = ROR.search!(
                          "names.value:Oxford",
                          page: 1
                        )
                        |> Map.get(:items)
                        |> List.first()
                        |> Map.get(:id)

      with_page_id = ROR.search!(
                       "names.value:Oxford",
                       page: 2
                     )
                     |> Map.get(:items)
                     |> List.first()
                     |> Map.get(:id)

      refute normal_first_id == with_page_id
    end

    test "accepts a filter option to specify a raw filter string" do
      assert %Organization{status: :inactive} = ROR.search!(
                                                  "names.value:Oxford",
                                                  filter: [
                                                    status: :inactive
                                                  ]
                                                )
                                                |> Map.get(:items)
                                                |> List.first()
    end

    test "accepts a Filter struct" do
      assert %Organization{status: :inactive} = ROR.search!(
                                                  "names.value:Oxford",
                                                  filter: Filter.new(status: :inactive)
                                                )
                                                |> Map.get(:items)
                                                |> List.first()
    end

    test "raises an exception if no search value is passed" do
      assert_raise RuntimeError, fn -> ROR.search!([page: 3]) end
      assert_raise RuntimeError, fn -> ROR.search!("") end
      assert_raise RuntimeError, fn -> ROR.search!(nil) end
    end

    test "will accept client_id string in opts and add an authentication header" do
      assert %Organization{} = ROR.search!("Oxford", client_id: "testing")
                               |> Map.get(:items)
                               |> List.first()
      ## TODO: This is not a useful test really
    end

  end

  describe "identify!/2" do

    test "accepts a value to search for and returns a Matches struct containing Match records" do
      assert %Matches{
               items: [
                 %Match{
                   chosen: true,
                   matching_type: :exact,
                   organization: %Organization{
                     id: "https://ror.org/04h699437"
                   }
                 } | _
               ]
             } = ROR.identify!("University of Leicester")
    end

    test "raises an exception if a page option is passed" do
      assert_raise RuntimeError, fn -> ROR.identify!("University of Leicester", page: 2) end
    end

    test "raises an exception if a filter option is passed" do
      assert_raise RuntimeError,
                   fn ->
                     ROR.identify!(
                       "University of Leicester",
                       filter: [
                         status: :inactive
                       ]
                     )
                   end
    end

    test "raises an exception if no search value is passed" do
      assert_raise RuntimeError, fn -> ROR.identify!([page: 3]) end
      assert_raise RuntimeError, fn -> ROR.identify!("") end
      assert_raise RuntimeError, fn -> ROR.identify!(nil) end
    end

    test "will accept client_id string in opts and add an authentication header" do
      assert %Matches{} = ROR.identify!("University of Leicester", client_id: "testing")
      ## TODO: This is not a useful test really
    end

  end

  describe "chosen_organization!/2" do

    test "accepts a value to search for and returns an Organization struct if one has been chosen" do
      assert %Organization{
               id: "https://ror.org/04h699437"
             } = ROR.chosen_organization!("University of Leicester")
    end

    test "accepts a value to search for and returns a nil if nothing has been chosen" do
      assert is_nil(ROR.chosen_organization!("this should find nothing at all"))
    end

    test "raises an exception if a page option is passed" do
      assert_raise RuntimeError, fn -> ROR.chosen_organization!("University of Leicester", page: 2) end
    end

    test "raises an exception if a filter option is passed" do
      assert_raise RuntimeError,
                   fn ->
                     ROR.chosen_organization!(
                       "University of Leicester",
                       filter: [
                         status: :inactive
                       ]
                     )
                   end
    end

    test "raises an exception if no search value is passed" do
      assert_raise RuntimeError, fn -> ROR.chosen_organization!([page: 3]) end
      assert_raise RuntimeError, fn -> ROR.chosen_organization!("") end
      assert_raise RuntimeError, fn -> ROR.chosen_organization!(nil) end
    end

    test "will accept client_id string in opts and add an authentication header" do
      assert %Organization{} = ROR.chosen_organization!("University of Leicester", client_id: "testing")
      ## TODO: This is not a useful test really
    end

  end

  describe "api_versions/0" do
    test "returns a list of supported API versions" do
      assert  ["v2.1"] = ROR.api_versions()
    end
  end

  describe "heartbeat?/1" do
    test "returns true if the API is available" do
      assert ROR.heartbeat?()
    end

    test "returns false if the API is not available" do
      refute ROR.heartbeat?(api_url: "https://incorrect.example.com/organizations")
    end

  end

end
