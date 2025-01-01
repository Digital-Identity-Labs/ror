defmodule ROR.Params do

  @moduledoc false

  alias ROR.Utils
  alias ROR.Filter

  @spec generate(opts :: keyword()) :: keyword()
  def generate(opts) do

    filter = Filter.new(opts[:filter])
             |> Filter.to_ror_param()

    page = page(opts[:page])

    all_status = opts[:all_status]


    [filter: filter, page: page, all_status: all_status]
    |> Enum.reject(fn {k, v} -> is_nil(v) end)

  end

  @spec query(value :: binary()) :: binary()
  def query(value) do
    Utils.escape_elastic(value)
  end

  @spec advanced_query(value :: binary()) :: binary()
  def advanced_query(value) do
    Utils.escape_elastic(value)
  end

  @spec page(page :: map() | nil | integer() | binary()) :: binary()
  def page(nil) do
    1
  end

  def page(%{page: page}) do
    page(page)
  end

  def page(zero) when zero == 0 or zero == "0" do
    "1"
  end

  def page(value) do
    "#{value}"
  end

end