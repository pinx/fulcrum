defmodule Fulcrum do
  use HTTPoison.Base
  alias Fulcrum.Form
  alias Fulcrum.Record

  require Logger

  def all(model) do
    resource = from_model(model)
    path = "#{resource_path(resource)}.json"
    {:ok, response} = HTTPoison.get endpoint <> path, headers
    # Logger.debug(inspect response)
    Poison.Parser.parse!(response.body)[pluralize(resource)]
    |> atomize
  end

  def get!(model, id) do
    resource = from_model(model)
    path = "#{resource_path(resource)}/#{id}.json"
    {:ok, response} = HTTPoison.get endpoint <> path, headers
    Poison.Parser.parse!(response.body)[resource]
    |> atomize
    # Poison.decode!(response.body, as: model)
  end

  def insert!(model) do
    resource = from_model(model)
    path = "#{resource_path(resource)}.json"
    body = Poison.encode!(model)
    {:ok, response} = HTTPoison.post endpoint <> path, body, headers
    Poison.Parser.parse!(response.body)[resource]
    |> atomize
    # Poison.decode!(response.body, as: model)
  end


  defp endpoint do
    Application.get_env(:fulcrum, :endpoint)
  end

  defp from_model(resource) when is_map(resource) do
    resource.__struct__
    |> extract_name
  end

  defp from_model(resource) do
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

  defp resource_path(resource) do
    "/" <> pluralize(resource)
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

  defp headers do
    [
      {"Content-Type", "application/json; charset=utf-8"},
      {"Accept", "application/json"},
      {"User-Agent", "Elixir Client"},
      {"X-ApiToken", Application.get_env(:fulcrum, :api_key)}
    ]
  end
end
