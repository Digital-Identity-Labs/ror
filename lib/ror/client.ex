defmodule ROR.Client do
  @moduledoc """
  Low-level functions for using the ROR REST API, returning maps parsed from the API's JSON responses.

  It's normally better to use the `ROR` module, unless you want to use the decoded JSON responses from the API, or
    pass parameters and headers directly.

  Parameters are passed as a map or keyword list of strings. They do not need to be URL-encoded (ROR will do that) but you must manually escape
    any ElasticSearch symbols. IDs are normalized. Things like changing the API base URL must be done by passing options
    to the `Req` HTTP library using the `:http` option.
  """

  @default_url "https://api.ror.org/v2/organizations"
  @default_heartbeat_url "https://api.ror.org/heartbeat"

  @default_http_options [
    base_url: @default_url,
    http_errors: :raise,
    cache: true,
    max_redirects: 3,
    max_retries: 3
  ]

  @common_options [http: @default_http_options, params: [], headers: [], api_url: nil]

  @default_get_options @common_options ++ []
  @allowed_get_options Keyword.keys(@default_get_options)

  @default_list_options @common_options ++ []
  @allowed_list_options Keyword.keys(@default_list_options)

  @default_query_options @common_options ++ []
  @allowed_query_options Keyword.keys(@default_query_options)

  @default_affiliation_options @common_options ++ []
  @allowed_affiliation_options Keyword.keys(@default_affiliation_options)

  alias ROR.ID

  @doc """
  Retrieve a single organization record as a map using its ROR ID.

  The ID can be any valid format: `https://ror.org/04h699437`, `ror.org/04h699437` or `04h699437`

  An exception will be raised if data cannot be returned

  You can read more about getting a single record in the [official ROR docs](https://ror.readme.io/v2/docs/api-single)

  ## Options
    * `params`: A map or keyword list of HTTP params that is passed to `Req` and merged with defaults (optional)
    * `headers`: A map or keyword list of HTTP headers that is passed to `Req` and merged with defaults (optional)
    * `http`: A map or keyword list of `Req` options that is passed to `Req` and merged with defaults (optional)

  ## Example
      iex> ROR.Client.get!("https://ror.org/04h699437")

  """
  @spec get!(id :: binary(), opts :: keyword()) :: map()
  def get!(id, opts \\ []) do
    opts =
      Keyword.merge(@default_get_options, opts || [])
      |> Keyword.take(@allowed_get_options)

    Req.get!(http(opts), url: ID.path(id), headers: opts[:headers]).body
  end

  @doc """
  Returns a map that contains organization records.

  An exception will be raised if a list of organizations data cannot be returned

  You can read more about getting a list of records in the [official ROR docs](https://ror.readme.io/v2/docs/api-list)

  ## Options
    * `params`: A map or keyword list of HTTP params that is passed to `Req` and merged with defaults (optional)
    * `headers`: A map or keyword list of HTTP headers that is passed to `Req` and merged with defaults (optional)
    * `http`: A map or keyword list of `Req` options that is passed to `Req` and merged with defaults (optional)


  ## Example
      iex> ROR.Client.list!(params: [page: "3", filter: "type:government"])

  """
  @spec list!(opts :: keyword()) :: map()
  def list!(opts \\ []) do
    opts =
      Keyword.merge(@default_list_options, opts || [])
      |> Keyword.take(@allowed_list_options)

    Req.get!(http(opts), params: opts[:params], headers: opts[:headers]).body
  end

  @doc """
  Searches names and external_ids in the ROR database and returns a map that has a list of organization records.

  This style of search is relatively quick and simple, and suitable for things like auto-suggestion lookups.

  An exception will be raised if results cannot be returned

  You can read more about querying records in the [official ROR docs](https://ror.readme.io/v2/docs/api-query)

  ## Options
    * `params`: A map or keyword list of HTTP params that is passed to `Req` and merged with defaults (optional)
    * `headers`: A map or keyword list of HTTP headers that is passed to `Req` and merged with defaults (optional)
    * `http`: A map or keyword list of `Req` options that is passed to `Req` and merged with defaults (optional)


  ## Example
      iex> ROR.Client.query!("'New York'", params: [page: "3"])

  """
  @spec query!(value :: binary(), opts :: keyword()) :: map()
  def query!(value, opts \\ []) do
    opts =
      Keyword.merge(@default_query_options, opts || [])
      |> Keyword.take(@allowed_query_options)

    if !is_binary(value), do: raise("No query string was passed to API call!")

    params = Keyword.merge(opts[:params], query: value)

    Req.get!(http(opts), params: params, headers: opts[:headers]).body
  end

  @doc """
  Searches all fields in the ROR database if given a simple string, or allows use of ElasticSearch-style search queries.
  Returns a map that has a list of organization records (also as maps).

  This API call is slower and more resource-intensive than `query/2` but allows more precision.

  An exception will be raised if results cannot be returned.

  You can read more about advanced queries in the [official ROR docs](https://ror.readme.io/v2/docs/api-advanced-query)

  ## Options
    * `params`: A map or keyword list of HTTP params that is passed to `Req` and merged with defaults (optional)
    * `headers`: A map or keyword list of HTTP headers that is passed to `Req` and merged with defaults (optional)
    * `http`: A map or keyword list of `Req` options that is passed to `Req` and merged with defaults (optional)


  ## Example
      iex> ROR.Client.query_advanced!("'Harvard University'", params: [page: "1"])
      ...> 
      ...> ROR.Client.query_advanced!(
      ...>   "names.value:Cornell AND locations.geonames_details.name:Ithaca"
      ...> )

  """
  @spec query_advanced!(value :: binary(), opts :: keyword()) :: map()
  def query_advanced!(value, opts \\ []) do
    opts =
      Keyword.merge(@default_query_options, opts || [])
      |> Keyword.take(@allowed_query_options)

    if !is_binary(value), do: raise("No query string was passed to API call!")

    params = Keyword.merge(opts[:params], "query.advanced": value)

    Req.get!(http(opts), params: params, headers: opts[:headers]).body
  end

  @doc """
  Attempts to find organizations that match the provided string, with levels of confidence that an organization has
   been identified. Returns a map of match results, each with an organization map.

  This API call is potentially useful for finding the correct ROR organization record for existing data, but must be used
    carefully.

  Results cannot be paged or filtered.

  An exception will be raised if matches cannot be returned.

  You can read more about affiliation queries in the [official ROR docs](https://ror.readme.io/v2/docs/api-affiliation)

  ## Options
    * `params`: A map or keyword list of HTTP params that is passed to `Req` and merged with defaults (optional)
    * `headers`: A map or keyword list of HTTP headers that is passed to `Req` and merged with defaults (optional)
    * `http`: A map or keyword list of `Req` options that is passed to `Req` and merged with defaults (optional)

  ## Example
      iex> ROR.affiliation!(
      ...>   "Department of Civil and Industrial Engineering, University of Pisa, Largo Lucio Lazzarino 2, Pisa 56126, Italy"
      ...> )

  """
  @spec affiliation!(value :: binary(), opts :: keyword()) :: map()
  def affiliation!(value, opts \\ []) do
    opts =
      Keyword.merge(@default_affiliation_options, opts || [])
      |> Keyword.take(@allowed_affiliation_options)

    if !is_binary(value), do: raise("No query string was passed to API call!")

    params = Keyword.merge(opts[:params], affiliation: value)

    if params[:filter], do: raise("Cannot pass a filter to this API function")
    if params[:page], do: raise("Cannot pass a page to this API function")

    Req.get!(http(opts), params: params, headers: opts[:headers]).body
  end

  @doc false
  @spec http(opts :: keyword()) :: map()
  def http(opts \\ []) do
    Keyword.merge(@default_http_options, Keyword.get(opts, :http, []))
    |> Keyword.merge(user_agent: http_agent_name(), base_url: base_url(opts))
    |> Req.new()
    |> CurlReq.Plugin.attach()
  end

  @doc false
  @spec http_agent_name() :: binary()
  def http_agent_name do
    "Elixir ROR Client #{Application.spec(:ror, :vsn)}"
  end

  @doc false
  @spec base_url(opts :: keyword()) :: binary()
  def base_url(opts) do
    cond do
      opts[:api_url] -> opts[:api_url]
      opts[:http] && opts[:http][:base_url] -> opts[:http][:base_url]
      true -> @default_url
    end
  end

  @doc false
  @spec heartbeat_url(opts :: keyword()) :: binary()
  def heartbeat_url(opts) do
    if opts[:api_url] do
      base_url(opts)
      |> URI.parse()
      |> URI.merge("/heartbeat")
    else
      @default_heartbeat_url
    end
  end

  @doc false
  @spec heartbeat!(opts :: keyword) :: boolean()
  def heartbeat!(opts \\ []) do
    opts =
      Keyword.merge(@default_get_options, opts || [])
      |> Keyword.take(@allowed_get_options)

    Req.get!(http(opts), base_url: heartbeat_url(opts), headers: opts[:headers]).body
  end

  ######################################################################################
end
