defmodule RorTest do
  use ExUnit.Case
  doctest Ror

  test "greets the world" do
    assert Ror.hello() == :world
  end
end
