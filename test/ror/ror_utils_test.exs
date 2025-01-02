defmodule RorUtilsTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Utils, as: ThisModule

  describe "escape_elastic/1" do

  end

end
