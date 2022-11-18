defmodule ChargebeeElixir.Invoice do
  @moduledoc """
  an interface for interacting with Invoices
  """
  use ChargebeeElixir.Resource, "invoice"

  def import_invoice(params \\ %{}) do 
    create(params, "/import_invoice") 
  end

  def close(id, params \\ %{}) do
    post_resource(id, "/close", params)
  end
end
