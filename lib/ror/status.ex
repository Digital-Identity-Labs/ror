defmodule ROR.Status do

  alias __MODULE__

  def extract(data) do
    String.to_atom(data["status"])
  end

end
