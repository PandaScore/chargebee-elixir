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
             }) == %{"addon[id]" => "addon-a", "object[id]" => "object-a"}
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
               "nested_objects[id][0]" => "object-a",
               "nested_objects[id][1]" => "object-b"
             }
    end
  end
end
