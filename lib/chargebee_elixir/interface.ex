defmodule ChargebeeElixir.Interface do
  @moduledoc """
  A low level http interface for interacting with Chargebee V2 HTTP Endpoints

  Configuration:
   - Authorization loaded from `:chargebee_elixir, :api_key`
   - Chargebee namespace scoping loaded from `:chargebee_elixir, :namespace`
   - Alternative HTTP Clients configured from `:chargebee_elixir, :http_client` (i.e. in testing)
  """
  alias Plug.Conn.Query

  def get(path) do
    get(path, %{})
  end

  def get(path, params) do
    params_string = URI.encode_query(params)

    url =
      [fullpath(path), params_string]
      |> Enum.filter(fn s -> String.length(s) > 0 end)
      |> Enum.join("?")

    http_client().get!(url, headers())
    |> handle_response()
  end

  def post(path, data) do
    body =
      data
      |> serialize()
      |> Query.encode()

    http_client().post!(
      fullpath(path),
      body,
      headers() ++ [{"Content-Type", "application/x-www-form-urlencoded"}]
    )
    |> handle_response()
  end

  defp handle_response(%{body: body, status_code: 200}) do
    Jason.decode!(body)
  end

  defp handle_response(%{body: body, status_code: 400}) do
    message =
      body
      |> Jason.decode!()
      |> Map.get("message")

    raise ChargebeeElixir.InvalidRequestError, message: message
  end

  defp handle_response(%{status_code: 401}) do
    raise ChargebeeElixir.UnauthorizedError
  end

  defp handle_response(%{status_code: 404}) do
    raise ChargebeeElixir.NotFoundError
  end

  defp handle_response(%{}) do
    raise ChargebeeElixir.UnknownError
  end

  defp http_client do
    Application.get_env(:chargebee_elixir, :http_client, HTTPoison)
  end

  defp fullpath(path) do
    # TODO someday: Allow multiple Chargebee Interfaces with multiple namespaces
    namespace = Application.get_env(:chargebee_elixir, :namespace)
    "https://#{namespace}.chargebee.com/api/v2#{path}"
  end

  defp headers do
    api_key =
      :chargebee_elixir
      |> Application.get_env(:api_key)
      |> Kernel.<>(":")
      |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key}
    ]
  end

  # serialize/3 is a 1:1 adaptation of Chargebee-Ruby `Chargebee::Util.serialize/3`
  # from https://github.com/chargebee/chargebee-ruby/blob/42f4aa5e58d5760d9f66d3aff02f8389faa6e68f/lib/chargebee/util.rb#L5
  def serialize(value, prefix \\ nil, index \\ nil)

  def serialize(value, prefix, index) when is_map(value) do
    Enum.flat_map(value, fn
      {k, v} when is_map(v) or is_list(v) ->
        serialize(v, k)

      {k, v} ->
        pt1 = if is_nil(prefix), do: to_string(k), else: "#{prefix}[#{k}]"
        pt3 = if is_nil(index), do: "", else: "[#{index}]"

        key = pt1 <> pt3
        [{key, to_string(v)}]
    end)
    |> Map.new()
  end

  def serialize(value, prefix, _index) when is_list(value) do
    value
    |> Enum.with_index()
    |> Enum.flat_map(fn {item, i} -> serialize(item, prefix, i) end)
    |> Map.new()
  end

  def serialize(_value, nil, nil) do
    raise ArgumentError, "Only hash or arrays are allowed as value"
  end

  def serialize(value, prefix, index) do
    key = "#{prefix}[#{index}]"

    [{key, value}]
  end
end
