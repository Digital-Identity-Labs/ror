defmodule ROR.Params do

  alias ROR.Utils
  alias ROR.Filter

  def generate(opts) do

    filter = Filter.new(opts[:filter])
             |> Filter.to_ror_param()

    page = page(opts[:page])

    all_status = opts[:all_status]


    [filter: filter, page: page, all_status: all_status]
    |> Enum.reject(fn {k, v} -> is_nil(v) end)

  end

  def query(value) do
    Utils.escape_elastic(value)
  end

  def advanced_query(value) do
    Utils.escape_elastic(value)
  end

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