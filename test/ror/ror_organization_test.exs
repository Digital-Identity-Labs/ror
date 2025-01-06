defmodule RorOrganizationTest do
  use ExUnit.Case

  @example_org_json File.read!("test/support/static/example_org.json")
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Organization, as: ThisModule
  alias ROR.Organization

  describe "extract/1" do
    test "returns an %Organization{} struct  when passed organization data" do
      assert %ThisModule{} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains an ID" do
      assert %ThisModule{id: "https://ror.org/00pjdza24"} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains an established year as a number" do
      assert %ThisModule{established: 1868} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains an status atom" do
      assert %ThisModule{status: :active} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains a list of types atoms" do
      assert %ThisModule{types: [:education]} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains an admin struct" do
      assert %ThisModule{
               admin: %ROR.Admin{
                 created_at: ~D[2020-04-25]
               }
             } = ThisModule.extract(@example_org_data)
    end

    test "the struct contains a list of domain strings" do
      assert %ThisModule{domains: ["universityofcalifornia.edu"]} =
               ThisModule.extract(@example_org_data)
    end

    test "the struct contains a list of ExternalID structs" do
      assert %ThisModule{external_ids: [%ROR.ExternalID{} | _]} =
               ThisModule.extract(@example_org_data)
    end

    test "the struct contains a list of Link structs" do
      assert %ThisModule{links: [%ROR.Link{} | _]} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains a list of Location structs" do
      assert %ThisModule{locations: [%ROR.Location{} | _]} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains a list of Name structs" do
      assert %ThisModule{names: [%ROR.Name{} | _]} = ThisModule.extract(@example_org_data)
    end

    test "the struct contains a list of Relationship structs" do
      assert %ThisModule{relationships: [%ROR.Relationship{} | _]} =
               ThisModule.extract(@example_org_data)
    end
  end

  describe "id/1" do
    test "Returns the minimal ID of this organization" do
      org = Organization.extract(@example_org_data)
      assert "00pjdza24" = Organization.id(org)
    end
  end

  describe "full_id/1" do
    test "Returns the full ID of this organization" do
      org = Organization.extract(@example_org_data)
      assert "https://ror.org/00pjdza24" = Organization.full_id(org)
    end
  end

  describe "vocab/1" do
    test "returns an empty list" do
      assert [] = Organization.vocab()
    end
  end

  describe "String.Chars Protocol" do
    test "returns a simple string representation when interpolated or otherwise converted to a string" do
      assert "https://ror.org/00pjdza24" = to_string(ThisModule.extract(@example_org_data))
    end
  end
end
