defmodule ROR do
  @moduledoc """
  `ROR` is an unofficial client for the [Research Organization Registry (ROR)](https://ror.org) API for Elixir.
  This top level `ROR` module contains functions for retrieving data via the API.

  > The Research Organization Registry (ROR) includes IDs and metadata for more than 110,000 organizations and counting.
  > Registry data is CC0 and openly available via a search interface, REST API, and data dump. Registry updates are curated
  > through a community process and released at least once a month

  Please read ROR's [terms of use](https://ror.org/about/terms/) and do not put excessive load on their API service.

  ## Features

  * Lookup individual ROR records by ID
  * Search and Quick Search based on names or record attributes
  * Paging and filters for queries and lists
  * Match text to records, possibly identifying an organisation from existing data
  * Records are returned as typed structs (slightly different to the ROR JSON responses, but containing all the information)
  * Client ID authentication is supported and optional
  * API service heartbeat checks
  * (This is an early version and only contains the basics so far)

   You may not need to use the other ROR modules directly at all, but here are a few that might be handy:

  * `ROR.Client` presents a lower-level way to retrieve data, and returns maps based on the literal ROR JSON responses.
  * `ROR.Organization` contains a struct and utilities for the main ROR organization record
  * `ROR.Results` is an enumerable struct that contains both Organizations and metadata
  * `ROR.Matches` is another enumerable struct, which contains results from affiliation searches

  ## Defining Filters

  Filters are used to fine-tune results before they are returned.

  > Results can be filtered by record status, organization type, ISO 3166 country code, country name, continent code, and continent name.

  In the `ROR` module they are defined directly using either a keyword list

      iex> ROR.list!(filter: [type: :government])

  or by creating a `ROR.Filter` struct, and passing that

      iex> my_filter = ROR.Filter.new(status: :inactive, types: :facility)
      ...> ROR.list!(filter: my_filter)

  You can read more about filters in the [official ROR docs](https://ror.readme.io/v2/docs/api-filtering)

  ## Authentication

  The ROR API does not require authentication, but it can be used to permit heavier usage. You must register on the ROR
  website for a key/token, and then include that in calls using the `:client_id` option like this:

      iex> ROR.get!("https://ror.org/04h699437", client_id: "client ID goes here")

  ## Paging

  API calls that return multiple results will limit them to pages of 20 organizations at a time, and default to page 1.

  You can specify pages using the `:page` option.

      iex> ROR.list!(page: 20)

  You can read more about paging in the [official ROR docs](https://ror.readme.io/v2/docs/api-paging)

  ## Results and Matches

  Results are returned as `ROR.Results` and `ROR.Matches` structs which contain a list of `ROR.Organization` structs
  and some metadata. They are enumerable, so you can use `Enum` functions on them directly.

  So, iterating through the items in the Results struct and iterating directly are equivalent

      iex> results = ROR.list!()
      ...> # this
      ...> Enum.map(results.items, fn o -> o.id end)
      ...> # can also be done like this
      ...> Enum.map(results, fn o -> o.id end)

  ## Stringifying ROR structs

  Many structs used by the ROR library can be converted to strings, and converted automatically if interpolated inside
  other strings. This can be useful when logging and debugging.

  Information will be lost, and the process is one-way - you cannot convert them back to structs from strings.

      iex> org = ROR.get!("https://ror.org/04h699437")
      ...> to_string(org)
      "https://ror.org/04h699437"
      iex> org = ROR.get!("https://ror.org/04h699437")
      ...> to_string(org.admin)
      "2018-11-14, 2024-12-11"

  ## Examples

  ### Retrieving data about an organization using its ROR ID

      iex> org = ROR.get!("https://ror.org/04h699437")
      ...> org.domains
      ["le.ac.uk"]

  ### List ROR records, specifying a page and a filter

      iex> ROR.list!(page: 15, filter: [type: :government])
      ...> |> Enum.map(fn org -> org.id end)
      ...> |> Enum.count()
      20

  ### A quick search

      iex> a =
      ...>   ROR.quick_search!("University of Manchester")
      ...>   |> Enum.take(1)
      ...>   |> List.first()
      ...> 
      ...> a.established
      1824

  ### An affiliation search for strong match or nil, also showing off the string conversion feature

      iex> org = ROR.chosen_organization!("CERN")
      ...> Enum.map(org.names, &to_string/1)
      [
        "CERN",
        "European Organization for Nuclear Research",
        "Europäische Organisation für Kernforschung",
        "Organisation européenne pour la recherche nucléaire"
      ]

  """

  alias ROR.Client
  alias ROR.Organization
  alias ROR.Params
  alias ROR.Results
  alias ROR.Matches
  alias ROR.ID

  @doc """
  Check if a single, specified record is available via the API, returning true or false.

  The ID can be any valid format: `https://ror.org/04h699437`, `ror.org/04h699437` or `04h699437`

  False will be returned if the ID is invalid, or the URL incorrect, or the record simply isn't available.

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)

  ## Example
      iex> ROR.exists?("https://ror.org/04h699437")
      true
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

  You can read more about getting a single record in the [official ROR docs](https://ror.readme.io/v2/docs/api-single)

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

  You can read more about getting a list of records in the [official ROR docs](https://ror.readme.io/v2/docs/api-list)

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
    Client.list!(
      api_url: Params.api_url(opts),
      params: Params.generate(opts),
      headers: Params.headers(opts)
    )
    |> Results.extract()
  end

  @doc """
  Searches names and external_ids in the ROR database and returns a Results struct that has a list of Organization structs.

  This style of search is relatively quick and simple, and suitable for things like auto-suggestion lookups.

  An exception will be raised if results cannot be returned

  You can read more about querying records in the [official ROR docs](https://ror.readme.io/v2/docs/api-query)

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

  You can read more about advanced queries in the [official ROR docs](https://ror.readme.io/v2/docs/api-advanced-query)

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)
    * `page`: a page number (optional)
    * `filter`: filter options, or a Filter Struct (optional)
    * `all_status`: set to `true` to return active, inactive and withdrawn organizations (optional)

  ## Example
      iex> ROR.search!("'Harvard University'", page: 1)
      ...> ROR.search!("names.value:Cornell AND locations.geonames_details.name:Ithaca")

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

  This API call is potentially useful for finding the correct ROR organization record for existing data, but must be used
    carefully.

  Results cannot be paged or filtered.

  An exception will be raised if matches cannot be returned.

  You can read more about affiliation queries in the [official ROR docs](https://ror.readme.io/v2/docs/api-affiliation)

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)

  ## Example
      iex> ROR.identify!(
      ...>   "Department of Civil and Industrial Engineering, University of Pisa, Largo Lucio Lazzarino 2, Pisa 56126, Italy"
      ...> )

  """
  @spec identify!(value :: binary(), opts :: keyword()) :: Matches.t()
  def identify!(search, opts \\ []) do
    if opts[:filter], do: raise("Cannot pass a filter to this API function")
    if opts[:page], do: raise("Cannot pass a page to this API function")

    Client.affiliation!(Params.query(search),
      api_url: Params.api_url(opts),
      headers: Params.headers(opts)
    )
    |> Matches.extract()
  end

  @doc """
  Attempts to identify **one** organization that has been chosen as a close match for the string, or returns nil if there
    is any ambiguity.

  Results cannot be paged or filtered.

  An exception will be raised if matches cannot be returned.

  ## Options
    * `api_url`: The base URL (optional)
    * `client_id`: ROR authentication token (optional)

  ## Example
      iex> ROR.chosen_organization!(
      ...>   "Department of Civil and Industrial Engineering, University of Pisa, Largo Lucio Lazzarino 2, Pisa 56126, Italy"
      ...> )

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
