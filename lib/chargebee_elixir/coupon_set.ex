defmodule ChargebeeElixir.CouponSet do
  @moduledoc """
  an interface for interacting with Coupon Sets

  Supports
   - List
   - Retrieve
   - Create
   - Update
  """
  use ChargebeeElixir.Resource, "coupon_set"

  def add_coupon_codes(coupon_id, params) do
    post_resource(coupon_id, "/add_coupon_codes", params)
  end

  def delete(coupon_id) do
    post_resource(coupon_id, "/delete", %{})
  end

  def delete_unused_coupon_codes(coupon_id) do
    post_resource(coupon_id, "/delete_unused_coupon_codes", %{})
  end
end
