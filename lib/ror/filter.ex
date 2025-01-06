defmodule ROR.Filter do
  @moduledoc """
  A structure for building simple ROR Filter strings

  """

  # @enforce_keys [:id]
  alias __MODULE__
  alias ROR.Status
  alias ROR.Type

  @type t :: %__MODULE__{
          status: binary() | atom(),
          types: binary() | atom(),
          country_code: binary() | atom(),
          country_name: binary() | atom(),
          continent_code: binary() | atom(),
          continent_name: binary() | atom()
        }

  defstruct status: nil,
            types: nil,
            country_code: nil,
            country_name: nil,
            continent_code: nil,
            continent_name: nil

  @doc """
  Creates a new Filter struct from a map or keyword list.

  Keys that can be passed are: `:status`, `:types`, `:country_code`, `:country_name`, `:continent_code`, `:continent_name`
    and also `:type`, which is corrected to `:types`.

  Passing an existing Filter struct returns the same struct

  ## Example

      iex> ROR.Filter.new(types: "funder", country_code: "DE")
      %ROR.Filter{
        status: nil,
        types: "funder",
        country_code: "DE",
        country_name: nil,
        continent_code: nil,
        continent_name: nil
      }

  """
  @spec new(input :: Filter.t() | keyword() | map()) :: Filter.t()
  def new(filter \\ [])

  def new(%Filter{} = filter) do
    filter
  end

  def new(filter_opts) do
    %Filter{
      status: filter_opts[:status],
      types: filter_opts[:types] || filter_opts[:type],
      country_code: filter_opts[:country_code],
      country_name: filter_opts[:country_name],
      continent_code: filter_opts[:continent_code],
      continent_name: filter_opts[:continent_name]
    }
    |> validate!()
  end

  @doc """
  Converts a Filter struct to a ROR filter string

  ## Example

      iex> ROR.Filter.new(types: "funder", country_code: "DE")
      iex> |> ROR.Filter.to_ror_param()
      "types:funder,locations.geonames_details.country_code:DE"

  """
  @spec to_ror_param(filter :: Filter.t() | keyword()) :: nil | binary()
  def to_ror_param(%Filter{
        status: nil,
        types: nil,
        country_code: nil,
        country_name: nil,
        continent_code: nil,
        continent_name: nil
      }) do
    nil
  end

  def to_ror_param(%Filter{} = filter) do
    filter
    |> Map.from_struct()
    |> Enum.map(fn {k, v} -> filterize(k, v) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(",")
  end

  ###############################################################################################################

  @spec validate!(filter :: Filter.t() | keyword()) :: Filter.t()
  defp validate!(filter) do
    if !is_nil(filter.status) && String.to_atom("#{filter.status}") not in Status.vocab(),
      do: raise("Invalid Filter status '#{filter.status}'")

    if !is_nil(filter.types) && String.to_atom("#{filter.types}") not in Type.vocab(),
      do: raise("Invalid Filter type '#{filter.types}'")

    filter
  end

  @spec filterize(key :: atom() | binary(), value :: atom() | binary()) :: binary()
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
