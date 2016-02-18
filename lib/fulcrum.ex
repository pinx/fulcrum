defmodule Fulcrum do
  use HTTPoison.Base

  @doc """
  Gets all Fulcrum objects of the given type.
  http://developer.fulcrumapp.com/endpoints/forms/
  ## Options
    * `:api_key` - if not specified, the organization's api key, as
      defined in the environment variable FULCRUM_API_KEY, is used.
      You can pass in a user's api_key, to filter by the objects to
      which the user is authorized.
  ## Example
    forms = Fulcrum.all(Form)
    forms = Fulcrum.all(Form)
  """
  def all(model, opts \\ []) do
    resource = resource_name(model)
    path = "#{resource_path(resource)}.json"
    {:ok, response} = HTTPoison.get endpoint <> path, headers(opts)
    to_model(response, model, pluralize(resource))
  end

  @doc """
  Like all/2, but with extra query params.
  The params are passed on as query params to Fulcrum,
  without any checks or limitations.
  http://developer.fulcrumapp.com/endpoints/records/#query-parameters
  ## Example
    records = Fulcrum.all(Record, [form_id: "<some id>"])
  """
  def all_by!(model, params, opts \\ []) do
    resource = resource_name(model)
    path = "#{resource_path(resource)}.json"
    {:ok, response} = HTTPoison.get endpoint <> path, headers(opts), params: params
    to_model(response, model, pluralize(resource))
  end

  @doc """
  Gets a Fulcrum object by id.
  It returns the object if it exists, otherwise
  throws an error.
  http://developer.fulcrumapp.com/endpoints/forms/
  ## Options
    * `:api_key` - if not specified, the organization's api key, as
      defined in the environment variable FULCRUM_API_KEY, is used.
      You can pass in a user's api_key, to filter by the objects to
      which the user is authorized.
  ## Example
    form = Fulcrum.get!(Form, "<UUID from Fulcrum>")
    form = Fulcrum.get!(Form, "<UUID from Fulcrum>")
  """
  def get!(model, id, opts \\ []) do
    resource = resource_name(model)
    path = "#{resource_path(resource)}/#{id}.json"
    {:ok, response} = HTTPoison.get endpoint <> path, headers(opts)
    to_model(response, model, resource)
  end

  @doc """
  Inserts a Fulcrum object.
  It returns the inserted object if the object has been successfully
  inserted or throws an error if there was a failure at
  the Fulcrum endpoint.
  NB: Many fields are required. Check the Fulcrum documentation.
  http://developer.fulcrumapp.com/endpoints/forms/
  ## Options
    * `:api_key` - if not specified, the organization's api key, as
      defined in the environment variable FULCRUM_API_KEY, is used.
      You can pass in a user's api_key, to filter by the objects to
      which the user is authorized.
  ## Example
    form = Fulcrum.insert!(%Form{id: "<UUID from Fulcrum>", ...(all the other field)...})
    form = Fulcrum.insert!(%Form{id: "<UUID from Fulcrum>", ...}, [api_key: "<api_key>"])
  """
  def insert!(model, opts \\ []) do
    case model.__struct__ do
      Fulcrum.FormMembership ->
        insert_form_membership(model, opts)
      _ ->
        resource = resource_name(model)
        path = "#{resource_path(resource)}.json"
        body = to_json(model)
        {:ok, response} = HTTPoison.post endpoint <> path, body, headers(opts)
        to_model(response, model, resource)
    end
  end

  @doc """
  Updates a Fulcrum object using its primary key.
  It returns the updated object if the object has been successfully
  updated or throws an error if there was a failure at
  the Fulcrum endpoint.
  NB: Fulcrum requires you to provide the FULL object. Any fields
  you leave empty, are cleared.
  http://developer.fulcrumapp.com/endpoints/forms/
  ## Options
    * `:api_key` - if not specified, the organization's api key, as
      defined in the environment variable FULCRUM_API_KEY, is used.
      You can pass in a user's api_key, to filter by the objects to
      which the user is authorized.
  ## Example
    form = Fulcrum.update!(%Form{id: "<UUID from Fulcrum>", ...(all the other field)...})
    form = Fulcrum.update!(%Form{id: "<UUID from Fulcrum>", ...}, [api_key: "<api_key>"])
  """
  def update!(model, opts \\ []) do
    resource = resource_name(model)
    path = "#{resource_path(resource)}/#{model.id}.json"
    body = to_json(model)
    {:ok, response} = HTTPoison.put endpoint <> path, body, headers(opts)
    to_model(response, model, resource)
  end

  @doc """
  Deletes a Fulcrum object using its primary key.
  It returns the object if the object has been successfully
  deleted or throws an error otherwise.
  http://developer.fulcrumapp.com/endpoints/forms/
  ## Options
    * `:api_key` - if not specified, the organization's api key, as
      defined in the environment variable FULCRUM_API_KEY, is used.
      You can pass in a user's api_key, to filter by the objects to
      which the user is authorized.
  ## Example
    form = Fulcrum.delete!(%Form{id: "<UUID from Fulcrum>"))
    form = Fulcrum.delete!(%Form{id: "<UUID from Fulcrum>"), [api_key: "<api_key>"])
  """
  def delete!(model, opts \\ []) do
    resource = resource_name(model)
    path = "#{resource_path(resource)}/#{model.id}.json"
    response = HTTPoison.delete! endpoint <> path, headers(opts)
    to_model(response, model, resource)
  end

  def from_json(model, json) do
    map = Poison.Parser.parse!(json)
      |> atomize
    struct(model, map)
  end

  def to_json(model) do
    "{\"#{resource_name(model)}\":#{Poison.encode!(model)}}"
  end

  # Fulcrum has a peculiar way of handling this endpoint
  defp insert_form_membership(model, opts \\ []) do
    %{form_id: form_id, membership_id: membership_id} = model
    path = "/memberships/change_permissions"
    instruction = %{change: %{type: "form_members", form_id: form_id, add: [membership_id]}}
    body = Poison.encode!(instruction)
    {:ok, response} = HTTPoison.post endpoint <> path, body, headers(opts)
    to_model(response, Fulcrum.Membership, "memberships")
  end

  defp to_model(response, model, resource) do
    body = response.body
    case response.status_code do
      s when s in 200..399 ->
        Poison.Parser.parse!(body)[resource]
        |> atomize
        |> to_model(model)
      s when s in 400..999 ->
        Poison.Parser.parse!(body)[resource]
        |> Map.fetch!("errors")
        |> Map.fetch!("base")
        |> Enum.join(", ")
        |> raise
    end
  end
  defp to_model(list, model) when is_list(list) and is_atom(model) do
    for item <- list, into: [], do: to_model(item, model)
  end
  defp to_model(map, model) when is_map(map), do: struct(model, map)

  defp to_error(response, resource) do
    failed_result = Poison.Parser.parse!(response.body)[resource]
    case failed_result do
      nil ->
        raise response.status
      result ->
        raise Enum.join(result["errors"]["base"], ", ")
    end
  end

  defp resource_path(resource) do
    "/" <> pluralize(resource)
  end

  defp resource_name(resource) when is_map(resource) do
    resource.__struct__
    |> extract_name
  end

  defp resource_name(resource) do
    resource
    |> extract_name
  end

  defp extract_name(resource) do
    resource
    |> Mix.Utils.underscore
    |> String.split("/")
    |> List.last
    |> to_string
  end

  defp pluralize(resource) do
    resource <> "s"
  end

  defp atomize(string_key_list) when is_list(string_key_list) do
    for item <- string_key_list, into: [], do: atomize(item)
  end

  defp atomize(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}
  end

  defp endpoint do
    Application.get_env(:fulcrum, :endpoint)
  end

  defp headers(opts) do
    api_key = Keyword.get(opts, :api_key, Application.get_env(:fulcrum, :api_key))
    [
      {"Content-Type", "application/json; charset=utf-8"},
      {"Accept", "application/json"},
      {"User-Agent", "Elixir Client"},
      {"X-ApiToken", api_key}
    ]
  end
end
