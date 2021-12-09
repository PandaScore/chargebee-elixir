defmodule ChargebeeElixir.Subscription do
  @moduledoc """
  an interface for interacting with Subscriptions
  """
  use ChargebeeElixir.Resource, "subscription"

  def create_for_customer(customer_id, params) do
    customer_id
    |> ChargebeeElixir.Customer.resource_path()
    |> create_for_parent(params)
  end
end
