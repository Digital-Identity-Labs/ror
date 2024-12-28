defmodule ROR.ID do

  @id_regex ~r/^0[a-hj-km-np-tv-z|0-9]{6}[0-9]{2}$/

  def normalize(id) do
    "https://ror.org/" <> minimize(id)
  end

  def minimize(id) do
    id
    |> String.trim()
    |> strip()
  end

  def path(id) do
    "/#{minimize(id)}"
  end

  def valid?(id) do
    try do
      mid = minimize(id)
      String.match?(mid, @id_regex) and checksum_ok?(mid)
    rescue
      _ -> false
    end
  end

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

  defp checksum_ok?(_id) do
    #https://github.com/ror-community/ror-api/blob/bd040a0d2558a478c06a89118a29eeb9b6142710/rorapi/management/commands/generaterorid.py#L8
    true
  end

end

#Full ROR ID URL: https://ror.org/015w2mp89
#Domain and ID: ror.org/015w2mp89
#ID only: 015w2mp89