defmodule ROR.Utils do

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
    String.replace(elastic_string, @elastic_special, fn m -> "\\" <> m end)
  end

end