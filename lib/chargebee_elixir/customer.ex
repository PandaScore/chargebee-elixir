defmodule ChargebeeElixir.Customer do
  @moduledoc """
  an interface for interacting with Customers
  """
  use ChargebeeElixir.Resource, "customer"

  def merge(args) do
    create(args, "/merge")
  end
end
