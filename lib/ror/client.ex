defmodule ROR.Client do

  @moduledoc """
  Low-level functions for calling the ROR REST API, returning maps parsed from the API's JSON responses.


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

  @default_get_options  @common_options ++ []
  @allowed_get_options  Keyword.keys(@default_get_options)

  @default_list_options @common_options ++ []
  @allowed_list_options Keyword.keys(@default_list_options)

  @default_query_options @common_options ++ []
  @allowed_query_options Keyword.keys(@default_query_options)

  @default_affiliation_options @common_options ++ []
  @allowed_affiliation_options Keyword.keys(@default_affiliation_options)

  alias ROR.ID

  @doc """
  XX
  """
  @spec get!(id :: binary(), opts :: keyword()) :: map()
  def get!(id, opts \\ []) do
    opts = Keyword.merge(@default_get_options, (opts || []))
           |> Keyword.take(@allowed_get_options)

    Req.get!(http(opts), url: ID.path(id), headers: opts[:headers]).body
  end

  @doc """
  XX
  """
  @spec list!(opts :: keyword()) :: map()
  def list!(opts \\ []) do
    opts = Keyword.merge(@default_list_options, (opts || []))
           |> Keyword.take(@allowed_list_options)

    Req.get!(http(opts), params: opts[:params], headers: opts[:headers]).body
  end

  @doc """
  XX
  """
  @spec query!(value :: binary(), opts :: keyword()) :: map()
  def query!(value, opts \\ []) do
    opts = Keyword.merge(@default_query_options, (opts || []))
           |> Keyword.take(@allowed_query_options)

    if !is_binary(value), do: raise "No query string was passed to API call!"

    params = Keyword.merge(opts[:params], [query: value])

    Req.get!(http(opts), params: params, headers: opts[:headers]).body
  end

  @doc """
  XX
  """
  @spec query_advanced!(value :: binary(), opts :: keyword()) :: map()
  def query_advanced!(value, opts \\ []) do
    opts = Keyword.merge(@default_query_options, (opts || []))
           |> Keyword.take(@allowed_query_options)

    if !is_binary(value), do: raise "No query string was passed to API call!"

    params = Keyword.merge(opts[:params], ["query.advanced": value])

    Req.get!(http(opts), params: params, headers: opts[:headers]).body
  end

  @doc """
  XX
  """
  @spec affiliation!(value :: binary(), opts :: keyword()) :: map()
  def affiliation!(value, opts \\ []) do
    opts = Keyword.merge(@default_affiliation_options, (opts || []))
           |> Keyword.take(@allowed_affiliation_options)

    if !is_binary(value), do: raise "No query string was passed to API call!"

    params = Keyword.merge(opts[:params], [affiliation: value])

    if params[:filter], do: raise "Cannot pass a filter to this API function"
    if params[:page], do: raise "Cannot pass a page to this API function"

    Req.get!(http(opts), params: params, headers: opts[:headers]).body
  end

  @doc false
  @spec http(opts :: keyword()) :: map()
  def http(opts \\ []) do
    Keyword.merge(@default_http_options, Keyword.get(opts, :http, []))
    |> Keyword.merge([user_agent: http_agent_name(), base_url: base_url(opts)])
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
    opts = Keyword.merge(@default_get_options, (opts || []))
           |> Keyword.take(@allowed_get_options)
    Req.get!(http(opts), base_url: heartbeat_url(opts), headers: opts[:headers]).body
  end

  ######################################################################################

end