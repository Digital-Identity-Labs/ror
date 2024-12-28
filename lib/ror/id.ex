defmodule ROR.ID do

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

end

#Full ROR ID URL: https://ror.org/015w2mp89
#Domain and ID: ror.org/015w2mp89
#ID only: 015w2mp89