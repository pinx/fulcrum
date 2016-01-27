defmodule Fulcrum.Form do
  @derive [Poison.Encoder]
  defstruct [:id, :name, :description, :elements]

  def from_json(json) do
    Poison.Parser.parse!(json)
    |> atomize
  end

  defp atomize(string_key_list) when is_list(string_key_list) do
    for item <- string_key_list, into: [], do: atomize(item)
  end

  defp atomize(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}
  end
end
