defmodule ROR do

  @moduledoc """
  `ROR` is an unofficial client for the [Research Organization Registry (ROR)](https://ror.org) API for Elixir, Erlang or
  any other BEAM language. This top level `ROR` module contains functions for retrieving data from the API.

  > The Research Organization Registry (ROR) includes IDs and metadata for more than 110,000 organizations and counting.
  > Registry data is CC0 and openly available via a search interface, REST API, and data dump. Registry updates are curated
  > through a community process and released at least once a month

  Please read ROR's [terms of use](https://ror.org/about/terms/) and do not put excessive load on their API service.

  ## Features

  * Lookup individual ROR records by ID
  * Search and Quick Search based on names or record attributes
  * Paging and filters are supported
  * Match text to records, possibly identifying an organisation from existing data
  * Records are returned as typed structs (slight different to the ROR JSON responses, but containing all the information)
  * Client ID authentication is supported and optional
  * (This is an early version and only contains the basics so far)

   You may not need to use the other ROR modules directly at all, but here are a few that might be handy:

  * `ROR.Client` presents a lower-level way to retrieve data, and returns maps based on the literal ROR JSON responses.
  * `ROR.Organization` contains a struct and utilities for the main ROR organization record
  * `ROR.Results` is an enumerable struct that contains both Organizations and metadata
  * `ROR.Matches` is another enumerable struct, which contains results from affiliation searches

  ## Defining Filters

  ## Authentication

  ## Pages

  ## Results and Matches

  ## Examples

  ### Retrieving data about an organization using its ROR ID

  ```elixir
  iex> org = ROR.get!("https://ror.org/04h699437")
  iex> org.domains
  ["le.ac.uk"]

  ```

  ### List ROR records, specifying a page and a filter

  ```elixir
  iex> ROR.list!(page: 15, filter: [type: :government])
  iex> |> Enum.map(fn org -> org.id end)
  iex> |> Enum.count()
  20
  ```

  ### A quick search

  ```elixir
  iex> a = ROR.quick_search!("University of Manchester")
  iex> |> Enum.take(1)
  iex> |> List.first()
  iex> a.established
  1824

  ```

  ### An affiliation search for strong match or nil, also showing off the string conversion feature

  ```elixir
  iex> org = ROR.chosen_organization!("CERN")
  iex> Enum.map(org.names, &to_string/1)
  ["CERN", "European Organization for Nuclear Research", "Europäische Organisation für Kernforschung", "Organisation européenne pour la recherche nucléaire"]
  ```

  """

  alias ROR.Client
  alias ROR.Organization
  alias ROR.Params
  alias ROR.Results
  alias ROR.Matches
  alias ROR.ID

  @doc """
  Retrieve a single Organization record using its ROR ID.

  The ID can be any valid format: `https://ror.org/04h699437`, `ror.org/04h699437` or `04h699437`

  An exception will be raised if an Organization cannot be returned

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)

  ## Example
      iex> ROR.get!("https://ror.org/04h699437")

  """
  @spec exists?(id :: binary(), opts :: keyword()) :: map()
  def exists?(id, opts \\ []) do
    try do
      org = get!(id, opts)
      ID.valid?(id) and ID.normalize(org.id) == ID.normalize(id)
    rescue
      _ -> false
    end
  end


  @doc """
  Retrieve a single Organization record using its ROR ID.

  The ID can be any valid format: `https://ror.org/04h699437`, `ror.org/04h699437` or `04h699437`

  An exception will be raised if an Organization cannot be returned

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)

  ## Example
      iex> ROR.get!("https://ror.org/04h699437")

  """
  @spec get!(id :: binary(), opts :: keyword()) :: map()
  def get!(id, opts \\ []) do
    Client.get!(id, api_url: Params.api_url(opts), headers: Params.headers(opts))
    |> Organization.extract()
  end

  @doc """
  Returns a Results struct that contains Organization structs.

  An exception will be raised if a list of organizations data cannot be returned

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)
    * `page`: a page number (optional)
    * `filter`: filter options, or a Filter Struct (optional)
    * `all_status`: set to `true` to return active, inactive and withdrawn organizations (optional)

  ## Example
      iex> ROR.list!(page: 3, filter: [type: :government])

  """
  @spec list!(opts :: keyword()) :: Results.t()
  def list!(opts \\ []) do
    Client.list!(api_url: Params.api_url(opts), params: Params.generate(opts), headers: Params.headers(opts))
    |> Results.extract()
  end

  @doc """
  Searches names and external_ids in the ROR database and returns a Results struct that has a list of Organization structs.

  This style of search is relatively quick and simple, and suitable for things like auto-suggestion lookups.

  An exception will be raised if results cannot be returned

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)
    * `page`: a page number (optional)
    * `filter`: filter options, or a Filter Struct (optional)
    * `all_status`: set to `true` to return active, inactive and withdrawn organizations (optional)

  ## Example
      iex> ROR.quick_search!("'New York'", page: 1)

  """
  @spec quick_search!(value :: binary(), opts :: keyword()) :: Results.t()
  def quick_search!(search, opts \\ []) do
    Client.query!(
      Params.query(search),
      api_url: Params.api_url(opts),
      params: Params.generate(opts),
      headers: Params.headers(opts)
    )
    |> Results.extract()
  end

  @doc """
  Searches all fields in the ROR database if given a simple string, or allows use of ElasticSearch-style search queries.
  Returns a Results struct that has a list of Organization structs.

  This API call is slower and more resource-intensive than `quick_search/2` but allows more precision.

  An exception will be raised if results cannot be returned.

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)
    * `page`: a page number (optional)
    * `filter`: filter options, or a Filter Struct (optional)
    * `all_status`: set to `true` to return active, inactive and withdrawn organizations (optional)

  ## Example
      iex> ROR.search!("'Harvard University'", page: 1)
      iex> ROR.search!("names.value:Cornell AND locations.geonames_details.name:Ithaca")

  """
  @spec search!(value :: binary(), opts :: keyword()) :: Results.t()
  def search!(search, opts \\ []) do
    Client.query_advanced!(
      Params.advanced_query(search),
      api_url: Params.api_url(opts),
      params: Params.generate(opts),
      headers: Params.headers(opts)
    )
    |> Results.extract()
  end

  @doc """
  Attempts to find organizations that match the provided string, with levels of confidence that an organization has
   been identified. Returns a Matches struct, which contains a list of Match records, each with an Organization.

  This API call is potentially useful for find the correct ROR organization record for existing data, but must be used
    carefully.

  Results cannot be paged or filtered.

  An exception will be raised if matches cannot be returned.

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)

  ## Example
      iex> ROR.identify!("Department of Civil and Industrial Engineering, University of Pisa, Largo Lucio Lazzarino 2, Pisa 56126, Italy")

  """
  @spec identify!(value :: binary(), opts :: keyword()) :: Matches.t()
  def identify!(search, opts \\ []) do

    if opts[:filter], do: raise "Cannot pass a filter to this API function"
    if opts[:page], do: raise "Cannot pass a page to this API function"

    Client.affiliation!(Params.query(search), api_url: Params.api_url(opts), headers: Params.headers(opts))
    |> Matches.extract()
  end

  @doc """
  Attempts to identify **one** organizations that has been chosen as a close match for the string, or returns nil if there
    is any ambiguity.

  Results cannot be paged or filtered.

  An exception will be raised if matches cannot be returned.

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)

  ## Example
      iex> ROR.chosen_organization!("Department of Civil and Industrial Engineering, University of Pisa, Largo Lucio Lazzarino 2, Pisa 56126, Italy")

  """
  @spec chosen_organization!(value :: binary(), opts :: keyword()) :: Organization.t() | nil
  def chosen_organization!(search, opts \\ []) do
    identify!(search, opts)
    |> Matches.chosen_organization()
  end

  @doc """
  Returns true if the API is available

    ## Options
    * `api_url`: The base URL (optional)

  ## Example
    iex> ROR.heartbeat?()
    true
    iex> ROR.heartbeat?(api_url: "https://incorrect.example.com/organizations")
    false
  """
  @spec heartbeat?(opts :: keyword) :: boolean()
  def heartbeat?(opts \\ []) do
    try do
      Client.heartbeat!(opts) == "OK"
    rescue
      _ -> false
    end
  end

  @doc """
  Returns a list of supported API versions.

  ## Example
    iex> ROR.api_versions()
    ["v2.1"]
  """
  @spec api_versions() :: list(binary())
  def api_versions() do
    ["v2.1"]
  end

end
