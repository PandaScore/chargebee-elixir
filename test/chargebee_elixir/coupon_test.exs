defmodule ChargebeeElixir.CouponTest do
  use ExUnit.Case
  doctest ChargebeeElixir.Coupon
  alias ChargebeeElixir.Coupon
  import Mox

  setup :verify_on_exit!

  def subject do
  end

  describe "create_for_items" do
    test "works with exmaple data from chargebee" do
      expect(
        ChargebeeElixir.HTTPoisonMock,
        :post!,
        fn url, data, _headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/coupons/create_for_items"

          assert URI.decode(data) ==
                   "apply_on=each_specified_item&discount_percentage=10.0&discount_type=percentage&duration_type=forever&id=summer_offer&item_constraints[constraint][0]=all&item_constraints[item_type][0]=plan&name=Summer+Offer"

          %{
            status_code: 200,
            body: '{"coupon": {"id": "summer_offer"}}'
          }
        end
      )

      assert Coupon.create_for_items(%{
               id: "summer_offer",
               name: "Summer Offer",
               discount_percentage: 10.0,
               discount_type: "percentage",
               duration_type: "forever",
               apply_on: "each_specified_item",
               item_constraints: [%{constraint: "all", item_type: "plan"}]
             }) == %{"id" => "summer_offer"}
    end

    test "works with list of  item_price_ids" do
      expect(
        ChargebeeElixir.HTTPoisonMock,
        :post!,
        fn url, data, _headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/coupons/create_for_items"

          assert URI.decode(data) ==
                   "apply_on=each_specified_item&discount_percentage=10.0&discount_type=percentage&duration_type=forever&id=summer_offer&item_constraints[constraint][0]=specific&item_constraints[item_price_ids][0]=[\"item_1\"]&item_constraints[item_type][0]=plan&name=Summer+Offer"

          %{
            status_code: 200,
            body: '{"coupon": {"id": "summer_offer"}}'
          }
        end
      )

      assert Coupon.create_for_items(%{
               id: "summer_offer",
               name: "Summer Offer",
               discount_percentage: 10.0,
               discount_type: "percentage",
               duration_type: "forever",
               apply_on: "each_specified_item",
               item_constraints: [
                 %{
                   constraint: "specific",
                   item_type: "plan",
                   item_price_ids: ["item_1"]
                 }
               ]
             }) == %{"id" => "summer_offer"}
    end
  end
end
