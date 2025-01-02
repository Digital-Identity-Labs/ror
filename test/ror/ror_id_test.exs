defmodule RorIDTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.ID, as: ThisModule

  describe "extract/1" do

  end

  describe "normalize/1" do

  end

  describe "minimize/1" do

  end

  describe "path/1" do

  end

  describe "valid?/1" do

  end

  describe "vocab/0" do

  end

end
