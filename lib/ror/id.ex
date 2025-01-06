defmodule ROR.ID do
  @moduledoc """
  Functions for extracting and using Admin data from a ROR Organization record

  IDs are simply a string
  """

  @id_regex ~r/^0[a-hj-km-np-tv-z|0-9]{6}[0-9]{2}$/

  @doc """
  Extracts an ID string from the decoded JSON of a ROR Organization record

  If you are retrieving records via the `ROR` module and the REST API you will not need to use this function yourself.

  ## Example

      iex> record = File.read!("test/support/static/example_org.json") |> Jason.decode!()
      ...> ROR.ID.extract(record)
      "https://ror.org/00pjdza24"

  """
  @spec extract(data :: map()) :: binary()
  def extract(data) do
    data["id"]
  end

  @doc """
  Takes any ID variant and returns a full ID

      iex> ID.normalize("00pjdza24")
      "https://ror.org/00pjdza24"
  """
  @spec normalize(id :: binary()) :: binary()
  def normalize(id) do
    "https://ror.org/" <> minimize(id)
  end

  @doc """
  Takes any variant of the ROR ID and returns only the record ID fragment

      iex> ID.minimize("https://ror.org/00pjdza24")
      "00pjdza24"
  """
  @spec minimize(id :: binary()) :: binary()
  def minimize(id) do
    id
    |> String.trim()
    |> strip()
  end

  @doc """
  Return a URL path for the ID

      iex> ID.minimize("https://ror.org/00pjdza24")
      "/00pjdza24"
  """
  @spec path(id :: binary()) :: binary()
  def path(id) do
    "/#{minimize(id)}"
  end

  @doc """
  Returns true if the ID is valid, false otherwise

      iex> ID.valid?("https://ror.org/00pjdza24")
      true
  """
  @spec valid?(id :: binary()) :: boolean()
  def valid?(id) do
    try do
      mid = minimize(id)
      String.match?(mid, @id_regex) and checksum_ok?(mid)
    rescue
      _ -> false
    end
  end

  @doc false
  @spec vocab() :: list(atom())
  def vocab do
    []
  end

  ###############################################################################################################

  @spec strip(id :: binary()) :: binary()
  defp strip("https://ror.org/" <> id) do
    strip(id)
  end

  defp strip("ror.org/" <> id) do
    strip(id)
  end

  defp strip("0" <> _ = id) when byte_size(id) == 9 do
    id
  end

  defp strip(id) do
    raise "ROR ID is unexpected: '#{id}'"
  end

  @spec checksum_ok?(id :: binary()) :: boolean()
  defp checksum_ok?(_id) do
    # https://github.com/ror-community/ror-api/blob/bd040a0d2558a478c06a89118a29eeb9b6142710/rorapi/management/commands/generaterorid.py#L8
    true
  end
end

# Full ROR ID URL: https://ror.org/015w2mp89
# Domain and ID: ror.org/015w2mp89
# ID only: 015w2mp89
