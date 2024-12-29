defmodule ROR.Filter do

  #@enforce_keys [:id]
  alias __MODULE__
  alias ROR.Status
  alias ROR.Type

  defstruct [
    status: nil,
    types: nil,
    country_code: nil,
    country_name: nil,
    continent_code: nil,
    continent_name: nil
  ]

  def new(%Filter{} = filter) do
    filter
  end

  def new(filter_opts \\ []) do
    %Filter{
      status: filter_opts[:status],
      types: filter_opts[:types] || filter_opts[:type],
      country_code: filter_opts[:country_code],
      country_name: filter_opts[:country_name],
      continent_code: filter_opts[:continent_code],
      continent_name: filter_opts[:continent_name],
    }
    |> validate!()
  end

  def to_ror_param(
        %{
          status: nil,
          types: nil,
          country_code: nil,
          country_name: nil,
          continent_code: nil,
          continent_name: nil
        }
      ) do
    nil
  end

  def to_ror_param(filter) do
    filter
    |> Map.from_struct()
    |> Enum.map(fn {k, v} -> filterize(k, v) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(",")
  end

  defp validate!(filter) do
    if !is_nil(filter.status) && !String.to_atom("#{filter.status}") in Status.vocab(),
       do: raise "Invalid Filter status '#{filter.status}'"
    if !is_nil(filter.types) && !String.to_atom("#{filter.types}") in Type.vocab(),
       do: raise "Invalid Filter type '#{filter.types}'"
    filter
  end

  defp filterize(_, nil) do
    nil
  end

  defp filterize(:status, value) do
    filterize("status", value)
  end

  defp filterize(:types, value) do
    filterize("types", value)
  end

  defp filterize(:country_code, value) do
    filterize("locations.geonames_details.country_code", value)
  end

  defp filterize(:country_name, value) do
    filterize("locations.geonames_details.country_name", value)
  end

  defp filterize(:continent_code, value) do
    filterize("locations.geonames_details.continent_code", value)
  end

  defp filterize(:continent_name, value) do
    filterize("locations.geonames_details.continent_name", value)
  end

  defp filterize(key, value) do
    "#{key}:#{value}"
  end

end
