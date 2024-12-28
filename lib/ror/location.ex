defmodule ROR.Location do

  #@enforce_keys [:id]
  alias __MODULE__

  defstruct [
    type: :geonames,
    id: nil,
    continent_name: nil,
    continent_code: nil,
    country_code: nil,
    country_name: nil,
    country_subdivision_code: nil,
    country_subdivision_name: nil,
    latitude: nil,
    longitude: nil,
    name: nil
  ]

  def extract(data) do
    for d <- data["locations"] do

      details = d["geonames_details"] || %{}

      %Location{
        id: d["geonames_id"],
        continent_name: details["continent_name"],
        continent_code: details["continent_code"],
        country_code: details["country_code"],
        country_name: details["country_name"],
        country_subdivision_name: details["country_subdivision_name"],
        country_subdivision_code: details["country_subdivision_code"],
        latitude: details["lat"],
        longitude: details["lng"],
        name: details["name"]
      }
    end
  end

  def vocab do
    [:geonames]
  end

end
