defmodule RorParamsTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Params, as: ThisModule

  describe "generate/1" do

  end

  describe "query/1" do

  end

  describe "advanced_query/1" do

  end

  describe "page/1" do

  end

end
