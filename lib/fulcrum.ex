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
    form = Fulcrum.all(Form)
    form = Fulcrum.all(Form)
  """
  def all(model, opts \\ []) do
    resource = resource_name(model)
    path = "#{resource_path(resource)}.json"
    {:ok, response} = HTTPoison.get endpoint <> path, headers(opts)
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
    resource = resource_name(model)
    path = "#{resource_path(resource)}.json"
    body = to_json(model)
    {:ok, response} = HTTPoison.post endpoint <> path, body, headers(opts)
    to_model(response, model, resource)
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

  defp to_model(response, model, resource) do
    Poison.Parser.parse!(response.body)[resource]
    |> atomize
    |> to_model(model)
  end

  defp to_model(list, model) when is_list(list) and is_atom(model) do
    for item <- list, into: [], do: to_model(item, model)
  end

  defp to_model(map, model) when is_map(map) do
    struct(model, map)
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
