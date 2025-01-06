defmodule ROR.Utils do
  @moduledoc false

  @elastic_special [
    "+",
    "-",
    "=",
    "&&",
    "||",
    ">",
    "<",
    "!",
    "(",
    ")",
    "{",
    "}",
    "[",
    "]",
    "^",
    "\"",
    "~",
    "*",
    "?",
    ":",
    "\\",
    "/"
  ]

  @spec escape_elastic(elastic_string :: binary()) :: binary()
  def escape_elastic(elastic_string) do
    if String.contains?(elastic_string, ":") do
      elastic_string
    else
      String.replace(elastic_string, @elastic_special, fn m -> "\\" <> m end)
    end
  end
end
