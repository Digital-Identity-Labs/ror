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
    elastic_string
  end

end
