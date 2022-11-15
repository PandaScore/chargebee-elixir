defmodule ChargebeeElixir.Invoice do
  use ChargebeeElixir.Resource, "invoice"
  def close(id, params \\ %{}) do post_endpoint(id, "/close", params) end
  def import_invoice(params \\ %{}) do create(params, "/import_invoice") end
end

  
