defmodule ChargebeeElixir.InterfaceTest do
  use ExUnit.Case

  describe "serialize" do
    test "chargebee example" do
      # from chargebee-ruby test case
      input = %{
        :id => "sub_KyVq7DNSNM7CSD",
        :plan_id => "free",
        :addons => [%{:id => "monitor", :quantity => 2}, %{:id => "ssl"}],
        :addon_ids => ["addon_one", "addon_two"],
        :card => %{
          :first_name => "Rajaraman",
          :last_name => "Santhanam",
          :number => "4111111111111111",
          :expiry_month => "1",
          :expiry_year => "2024",
          :cvv => "007"
        }
      }

      output = %{
        "id" => "sub_KyVq7DNSNM7CSD",
        "plan_id" => "free",
        "addons[id][0]" => "monitor",
        "addons[quantity][0]" => "2",
        "addons[id][1]" => "ssl",
        "addon_ids[0]" => "addon_one",
        "addon_ids[1]" => "addon_two",
        "card[first_name]" => "Rajaraman",
        "card[last_name]" => "Santhanam",
        "card[number]" => "4111111111111111",
        "card[expiry_month]" => "1",
        "card[expiry_year]" => "2024",
        "card[cvv]" => "007"
      }

      assert ChargebeeElixir.Interface.serialize(input) == output
    end

    test "chargebeee example 2" do
      # From the chargebee-go Test case
      input = %{
        plan_id: "cbdemo_grow",
        customer: %{
          email: "john@user.com",
          first_name: "John",
          last_name: "Doe",
          locale: "frCA",
          phone: "+19499999999",
          auto_collection: "on"
        },
        addons: [
          %{
            id: "cbdemo_conciergesupport"
          },
          %{
            id: "cbdemo_additionaluser",
            quantity: 2
          }
        ],
        coupon_ids: ["cbdemo_earlybird"]
      }

      output = %{
        "coupon_ids[0]" => "cbdemo_earlybird",
        "customer[phone]" => "+19499999999",
        "plan_id" => "cbdemo_grow",
        "customer[last_name]" => "Doe",
        "customer[locale]" => "frCA",
        "addons[id][0]" => "cbdemo_conciergesupport",
        "addons[id][1]" => "cbdemo_additionaluser",
        "addons[quantity][1]" => "2",
        "customer[email]" => "john@user.com",
        "customer[auto_collection]" => "on",
        "customer[first_name]" => "John"
      }

      assert ChargebeeElixir.Interface.serialize(input) == output
    end

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

    test "Example of complex nested list field" do
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
               "item_constraints[item_price_ids][0]" => "[\"item_a\"]"
             }
    end

    test "when query encoded" do
      input = %{
        item_constraints: [
          %{
            constraint: "specific",
            item_type: "plan",
            item_price_ids: "[\"item_a\"]"
          }
        ]
      }

      as_encoded_params =
        ~s<item_constraints[constraint][0]=specific&item_constraints[item_price_ids][0]=["item_a"]&item_constraints[item_type][0]=plan>

      assert as_encoded_params ==
               input
               |> ChargebeeElixir.Interface.serialize()
               |> URI.encode_query()
               |> URI.decode()
    end

    test "drops nil fields" do
      # from chargebee-ruby test case
      input = %{
        :id => "sub_KyVq7DNSNM7CSD",
        :plan_id => "free",
        :item_family_id => nil
      }

      output = %{
        "id" => "sub_KyVq7DNSNM7CSD",
        "plan_id" => "free"
      }

      assert ChargebeeElixir.Interface.serialize(input) == output
    end

    test "serializes metadata as encoded json" do
      input = %{metadata: %{some: "value"}}

      output = %{"metadata" => ~S({"some":"value"})}

      assert ChargebeeElixir.Interface.serialize(input) == output
    end
  end
end
