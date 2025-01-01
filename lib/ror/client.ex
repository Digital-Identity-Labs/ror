defmodule ROR.Client do

  @default_url "https://api.ror.org/v2/organizations"

  @default_http_options [
    base_url: @default_url,
    http_errors: :raise,
    cache: true,
    max_redirects: 3,
    max_retries: 3
  ]

  @common_options [http: @default_http_options, params: [], api_url: @default_url]

  @default_get_options  @common_options ++ []
  @allowed_get_options  Keyword.keys(@default_get_options)

  @default_list_options @common_options ++ []
  @allowed_list_options Keyword.keys(@default_list_options)

  @default_query_options @common_options ++ []
  @allowed_query_options Keyword.keys(@default_query_options)

  @default_affiliation_options @common_options ++ []
  @allowed_affiliation_options Keyword.keys(@default_affiliation_options)

  alias ROR.ID

  @spec http(opts :: keyword()) :: map()
  def http(opts \\ []) do
    Keyword.merge(@default_http_options, (opts || []))
    |> Keyword.merge([user_agent: http_agent_name()])
    |> Req.new()
    |> CurlReq.Plugin.attach()
  end

  @spec get!(id :: binary(), opts :: keyword()) :: map()
  def get!(id, opts \\ []) do
    opts = Keyword.merge(@default_get_options, (opts || []))
           |> Keyword.take(@allowed_get_options)

    Req.get!(http(opts[:http]), url: ID.path(id)).body
  end

  @spec list!(opts :: keyword()) ::  map()
  def list!(opts \\ []) do
    opts = Keyword.merge(@default_list_options, (opts || []))
           |> Keyword.take(@allowed_list_options)

    Req.get!(http(opts[:http]), params: opts[:params]).body
  end

  @spec query!(value :: binary(), opts :: keyword()) ::  map()
  def query!(value, opts \\ []) do
    opts = Keyword.merge(@default_query_options, (opts || []))
           |> Keyword.take(@allowed_query_options)

    params = Keyword.merge(opts[:params], [query: value])

    Req.get!(http(opts[:http]), params: params).body
  end

  @spec query_advanced!(value :: binary(), opts :: keyword()) ::  map()
  def query_advanced!(value, opts \\ []) do
    opts = Keyword.merge(@default_query_options, (opts || []))
           |> Keyword.take(@allowed_query_options)

    params = Keyword.merge(opts[:params], ["query.advanced": value])

    Req.get!(http(opts[:http]), params: params).body
  end

  @spec affiliation!(value :: binary(), opts :: keyword()) :: map()
  def affiliation!(value, opts \\ []) do
    opts = Keyword.merge(@default_affiliation_options, (opts || []))
           |> Keyword.take(@allowed_affiliation_options)

    params = Keyword.merge(opts[:params], [affiliation: value])

    Req.get!(http(opts[:http]), params: params).body
  end

  @spec http_agent_name() :: binary()
  def http_agent_name do
    "Elixir ROR Client" #{Application.spec(:ror, :vsn)}"
  end

end