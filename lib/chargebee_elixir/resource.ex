defmodule ChargebeeElixir.Resource do
  @moduledoc false
  defmacro __using__(resource) do
    quote location: :keep do
      alias ChargebeeElixir.Interface

      @resource unquote(resource)
      @resource_plural Inflex.pluralize(@resource)

      def retrieve(id) do
        id |> resource_path() |> Interface.get() |> Map.get(@resource)
      rescue
        ChargebeeElixir.NotFoundError -> nil
      end

      def list(params \\ %{}) do
        # Should pagination be by default?
        case Interface.get(resource_base_path(), params) do
          %{"list" => current_list, "next_offset" => next_offset} ->
            Enum.map(current_list, &Map.get(&1, @resource)) ++
              __MODULE__.list(Map.merge(params, %{"offset" => next_offset}))

          %{"list" => current_list} ->
            Enum.map(current_list, &Map.get(&1, @resource))
        end
      end

      def create(params, path \\ "") do
        resource_base_path()
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def post_resource(resource_id, endpoint, params) do
        resource_id
        |> resource_path()
        |> Kernel.<>(endpoint)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def create_for_parent(parent_path, params, path \\ "") do
        parent_path
        |> Kernel.<>(resource_base_path())
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def update(resource_id, params, path \\ "") do
        resource_id
        |> resource_path()
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
      end

      def resource_base_path do
        "/#{@resource_plural}"
      end

      def resource_path(id) do
        encoded_id = id |> to_string |> URI.encode()

        "#{resource_base_path()}/#{encoded_id}"
      end
    end
  end
end
