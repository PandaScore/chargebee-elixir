defmodule ChargebeeElixir.Coupon do
  @moduledoc """
  an interface for interacting with Coupons
  """
  use ChargebeeElixir.Resource, "coupon"

  def create_for_items(params) do
    create(params, "/create_for_items")
  end

  def update_for_items(coupon_id, params) do
    post_resource(coupon_id, "/update_for_items", params)
  end

  def delete(coupon_id) do
    post_resource(coupon_id, "/delete", %{})
  end

  def copy(coupon_id, params) do
    post_resource(coupon_id, "/copy", params)
  end

  def unarchive(coupon_id) do
    post_resource(coupon_id, "/unarchive", %{})
  end
end
