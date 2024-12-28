defmodule ROR.Domain do

  #@enforce_keys [:id]
  alias __MODULE__

  def extract(%{"domains" => missing}) when is_nil(missing) or missing == [] do
    []
  end

  def extract(data) do
    data["domains"]
    |> Enum.map(fn d -> d end)
  end

  def vocab do
    []
  end

end
