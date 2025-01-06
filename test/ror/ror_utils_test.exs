defmodule RorUtilsTest do
  use ExUnit.Case

  alias ROR.Utils

  describe "escape_elastic/1" do
    test "returns an escaped Elastic Search style query string" do
      assert "This \\&& That" = Utils.escape_elastic("This && That")
    end

    test "URI encoding is not done at this stage, Req handles that" do
      assert "Bath College" = Utils.escape_elastic("Bath College")
    end
  end
end
