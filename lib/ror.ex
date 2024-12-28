defmodule ROR do

  alias ROR.Client
  alias ROR.Organization

  def get!(id, opts \\ []) do
    Client.get!(id, opts)
    |> Organization.extract()
  end


end
