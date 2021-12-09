defmodule ChargebeeElixir.Invoice do
  use ChargebeeElixir.Resource, "invoice"

  def close(id, params \\ %{}) do
    post_resource(id, "/close", params)
  end
end
