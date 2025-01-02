defmodule RorIDTest do
  use ExUnit.Case

  @example_org_json File.read! "test/support/static/example_org.json"
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.ID, as: ThisModule
  alias ROR.ID

  describe "extract/1" do

    test "Extracts a single ID string from the raw ROR data map" do
      assert "https://ror.org/00pjdza24" = ID.extract(@example_org_data)
    end

  end

  describe "normalize/1" do

    test "Processes a full ID, returns a full ID" do
      assert "https://ror.org/00pjdza24" = ID.normalize("https://ror.org/00pjdza24")
    end

    test "Processes a partial ID, returns a full ID" do
      assert "https://ror.org/00pjdza24" = ID.normalize("ror.org/00pjdza24")
    end

    test "Processes a minimal ID, returns a full ID" do
      assert "https://ror.org/00pjdza24" = ID.normalize("00pjdza24")
    end

  end

  describe "minimize/1" do

    test "Processes a full ID, returns a minimal ID" do
      assert "00pjdza24" = ID.minimize("https://ror.org/00pjdza24")
    end

    test "Processes a partial ID, returns a minimal ID" do
      assert "00pjdza24" = ID.minimize("ror.org/00pjdza24")
    end

    test "Processes a minimal ID, returns a minimal ID" do
      assert "00pjdza24" = ID.minimize("00pjdza24")
    end

  end

  describe "path/1" do

    test "Processes a full ID, returns a GET path component" do
      assert "/00pjdza24" = ID.path("https://ror.org/00pjdza24")
    end

    test "Processes a partial ID, returns a GET path component" do
      assert "/00pjdza24" = ID.path("ror.org/00pjdza24")
    end

    test "Processes a minimal ID, returns a GET path component" do
      assert "/00pjdza24" = ID.path("00pjdza24")
    end

  end

  describe "valid?/1" do

    test "returns true if a minimal ID is valid" do
      assert ID.valid?("00pjdza24")
    end

    test "returns true if a full ID is valid" do
      assert ID.valid?("https://ror.org/00pjdza24")
    end

  end

  describe "vocab/0" do

    test "Returns an empty list" do
      assert [] = ID.vocab()
    end

  end

end
