defmodule RorTypeTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Type, as: ThisModule

  describe "extract/1" do


  end

end
