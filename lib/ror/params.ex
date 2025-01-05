defmodule ROR.Params do

  @moduledoc false

  alias ROR.Utils
  alias ROR.Filter

  @spec generate(opts :: keyword()) :: keyword()
  def generate(opts) do

    filter = filter(opts[:filter])

    page = page(opts[:page])

    all_status = opts[:all_status]


    [filter: filter, page: page, all_status: all_status]
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)

  end

  @spec query(value :: binary()) :: binary()
  def query("") do
    raise "Query string parameter is empty!"
  end

  def query(value) when is_binary(value) do
    Utils.escape_elastic(value)
  end

  def query(nil) do
    raise "Query string parameter is nil!"
  end

  def query(value) when is_atom(value) or is_integer(value) do
    query("#{value}")
  end

  def query(value)  do
    raise "Query string parameter was not actually a string!"
  end

  @spec advanced_query(value :: binary()) :: binary()
  def advanced_query("") do
    raise "Query string parameter is empty!"
  end

  def advanced_query(value) when is_binary(value) do
    Utils.escape_elastic(value)
  end

  def advanced_query(nil) do
    raise "Query string parameter is nil!"
  end

  def advanced_query(value) when is_atom(value) or is_integer(value) do
    query("#{value}")
  end

  def advanced_query(value)  do
    raise "Query string parameter was not actually a string!"
  end

  @spec page(page :: map() | nil | integer() | binary()) :: binary()
  def page(nil) do
    nil
  end

  def page(%{page: page}) do
    page(page)
  end

  def page(zero) when zero == 0 or zero == "0" do
    nil
  end

  def page(value) do
    "#{value}"
  end

  @spec headers(opts :: keyword()) :: keyword()
  def headers(opts) do
    if opts[:client_id] do
      [
        client_id: [opts[:client_id]]
      ]
    else
      []
    end
  end

  @spec query(value :: binary() | keyword() | map() | Filter.t()) :: binary()
  def filter(filter) do
    Filter.new(filter)
    |> Filter.to_ror_param()
  end

  @spec api_url(opts :: keyword()) :: binary() | nil
  def api_url(opts) do
    if opts[:api_url] do
      opts[:api_url]
    else
      nil
    end
  end

end