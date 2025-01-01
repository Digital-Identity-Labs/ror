defimpl Enumerable, for: ROR.Results do

  @moduledoc false

  def count(_list), do: {:error, __MODULE__}
  def member?(_list, _value), do: {:error, __MODULE__}
  def slice(_list), do: {:error, __MODULE__}

  def reduce(%{items: items}, acc, fun), do: reduce(items, acc, fun)
  def reduce(_, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(list, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(list, &1, fun)}
  def reduce([], {:cont, acc}, _fun), do: {:done, acc}
  def reduce([h | t], {:cont, acc}, fun), do: reduce(t, fun.(h, acc), fun)

end

defimpl Enumerable, for: ROR.Matches do

  @moduledoc false

  def count(_list), do: {:error, __MODULE__}
  def member?(_list, _value), do: {:error, __MODULE__}
  def slice(_list), do: {:error, __MODULE__}

  def reduce(%{items: items}, acc, fun), do: reduce(items, acc, fun)
  def reduce(_, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(list, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(list, &1, fun)}
  def reduce([], {:cont, acc}, _fun), do: {:done, acc}
  def reduce([h | t], {:cont, acc}, fun), do: reduce(t, fun.(h, acc), fun)

end