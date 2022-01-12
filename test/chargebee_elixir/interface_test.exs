defmodule ChargebeeElixir.InterfaceTest do
  use ExUnit.Case

  describe "serialize" do
    test "simple list" do
      assert ChargebeeElixir.Interface.serialize([
               %{id: "object-a"},
               %{id: "object-b"}
             ]) == %{"id[0]" => "object-a", "id[1]" => "object-b"}
    end

    test "deep nesting, no lists" do
      assert ChargebeeElixir.Interface.serialize(%{
               addon: %{
                 id: "addon-a",
                 nested: %{
                   object: %{
                     id: "object-a"
                   }
                 }
               }
             }) == %{"addon[id]" => "addon-a", "addon[nested][object][id]" => "object-a"}
    end

    test "simple nesting" do
      assert ChargebeeElixir.Interface.serialize(%{
               addons: [
                 %{
                   id: "addon-a",
                   price: 10
                 },
                 %{
                   id: "addon-b",
                   quantity: 2
                 }
               ]
             }) == %{
               "addons[id][0]" => "addon-a",
               "addons[id][1]" => "addon-b",
               "addons[price][0]" => "10",
               "addons[quantity][1]" => "2"
             }
    end

    test "complex nesting" do
      assert ChargebeeElixir.Interface.serialize(%{
               addons: [
                 %{
                   id: "addon-a",
                   price: 10,
                   nested_objects: [
                     %{
                       id: "object-a"
                     },
                     %{
                       id: "object-b"
                     }
                   ]
                 },
                 %{
                   id: "addon-b",
                   quantity: 2
                 }
               ]
             }) == %{
               "addons[id][0]" => "addon-a",
               "addons[id][1]" => "addon-b",
               "addons[price][0]" => "10",
               "addons[quantity][1]" => "2",
               "addons[nested_objects][id][0]" => "object-a",
               "addons[nested_objects][id][1]" => "object-b"
             }
    end

    test "failing complex nesting case" do
      assert ChargebeeElixir.Interface.serialize(%{
               item_constraints: [
                 %{
                   constraint: "specific",
                   item_type: "plan",
                   item_price_ids: ["item_a"]
                 }
               ]
             }) == %{
               "item_constraints[constraint][0]" => "specific",
               "item_constraints[item_type][0]" => "plan",
               "item_constraints[item_price_ids][0]" => "item_a"
             }
    end
  end
end
