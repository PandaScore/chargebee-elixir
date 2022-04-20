defmodule ChargebeeElixir.Gift do
  @moduledoc """
  An interface for interacting with Chargebee Gifts
  """
  use ChargebeeElixir.Resource, "gift"

  def create_for_items(params) do
    create(params, "/create_for_items")
  end

  def cancel(coupon_id) do
    post_resource(coupon_id, "/cancel", %{})
  end

  def claim(coupon_id) do
    post_resource(coupon_id, "/claim", %{})
  end
end
