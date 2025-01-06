defmodule RorAdminTest do
  use ExUnit.Case

  @example_org_json File.read!("test/support/static/example_org.json")
  @example_org_data Jason.decode!(@example_org_json)

  alias ROR.Admin, as: ThisModule
  alias ROR.Admin

  describe "extract/1" do
    test "returns an %Admin{} struct when passed organization data" do
      assert %ThisModule{} = ThisModule.extract(@example_org_data)
    end

    test "contains the created.date from the original JSON record, as a Date in created_at field" do
      assert %Admin{created_at: ~D[2020-04-25]} = Admin.extract(@example_org_data)
    end

    test "contains the created.schema_version from the original JSON record, as string in created_schema" do
      assert %Admin{created_schema: "1.0"} = Admin.extract(@example_org_data)
    end

    test "contains the last_modified.date from the original JSON record, as a Date in updated_at field" do
      assert %Admin{updated_at: ~D[2022-10-18]} = Admin.extract(@example_org_data)
    end

    test "contains the last_modified.schema from the original JSON record, as updated_schema" do
      assert %Admin{updated_schema: "2.0"} = Admin.extract(@example_org_data)
    end
  end

  describe "String.Chars Protocol" do
    test "returns a simple string representation when interpolated or otherwise converted to a string" do
      assert "2020-04-25, 2022-10-18" = to_string(ThisModule.extract(@example_org_data))
    end
  end
end
