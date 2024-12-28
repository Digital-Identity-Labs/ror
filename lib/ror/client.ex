defmodule ROR.Client do

  @default_url "https://api.ror.org/v2/organizations"

  alias ROR.ID

  def http() do
    Req.new(base_url: @default_url, http_errors: :raise)
  end

  def get!(id) do
    Req.get!(http(), url: ID.path(id)).body
  end

  def list!(opts \\ [params: []]) do
    Req.get!(http(), params: opts[:params]).body
  end

end