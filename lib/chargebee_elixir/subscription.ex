defmodule ChargebeeElixir.Subscription do
  use ChargebeeElixir.Resource, "subscription"

  def create_for_customer(customer_id, params) do
    customer_id
    |> ChargebeeElixir.Customer.resource_path()
    |> create_for_parent(params)
  end
end
