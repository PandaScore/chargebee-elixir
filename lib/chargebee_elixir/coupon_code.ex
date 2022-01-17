defmodule ChargebeeElixir.CouponCode do
  @moduledoc """
  an interface for interacting with Coupon Codes

  Supports:
   - List
   - Retrieve
  """
  use ChargebeeElixir.Resource, "coupon_code"

  def archive(coupon_code) do
    post_resource(coupon_code, "/archive", %{})
  end
end
