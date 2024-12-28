defmodule ROR do

  alias ROR.Client
  alias ROR.Organization

  def get!(id, opts \\ []) do
    Client.get!(id, opts)
    |> Organization.extract()
  end

  def list!(opts \\ [params: []]) do
    Client.list!(opts)
    |> Map.get("items", [])
    |> Enum.map(fn d -> Organization.extract(d) end)
  end

end
