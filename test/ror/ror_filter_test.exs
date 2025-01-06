defmodule RorFilterTest do
  use ExUnit.Case

  @example_org_json File.read!("test/support/static/example_org.json")
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Filter, as: ThisModule
  alias ROR.Filter

  describe "new/1" do
    test "Accepts options to set each field of filter" do
      filter = %Filter{
        status: "active",
        types: "funder",
        country_code: "DE",
        country_name: "Germany",
        continent_code: nil,
        continent_name: nil
      }

      assert ^filter =
               Filter.new(
                 status: "active",
                 types: "funder",
                 country_code: "DE",
                 country_name: "Germany"
               )
    end

    test "Accepts an existing filter and passes it through unchanged" do
      filter = %Filter{
        status: "active",
        types: "funder",
        country_code: "DE",
        country_name: "Germany",
        continent_code: nil,
        continent_name: nil
      }

      assert ^filter = Filter.new(filter)
    end

    test "will accept :type for types field, if :types is not used, to avoid confusion" do
      assert %Filter{
               types: "funder"
             } = Filter.new(type: "funder")
    end
  end

  describe "to_ror_param/1" do
    test "Converts Filter struct to a ROR filter string" do
      filter = %Filter{
        status: "active",
        types: "funder",
        country_code: "DE",
        country_name: "Germany",
        continent_code: nil,
        continent_name: nil
      }

      assert "status:active,types:funder,locations.geonames_details.country_code:DE,locations.geonames_details.country_name:Germany" =
               Filter.to_ror_param(filter)
    end
  end
end
