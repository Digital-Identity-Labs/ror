defmodule ROR.Type do

  alias __MODULE__

  def extract(data) do
    Enum.map(data["types"], fn t -> String.to_atom(t) end)
  end

end
