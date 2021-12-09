defmodule ChargebeeElixir.Invoice do
  @moduledoc """
  an interface for interacting with Invoices
  """
  use ChargebeeElixir.Resource, "invoice"

  def close(id, params \\ %{}) do
    post_resource(id, "/close", params)
  end
end
