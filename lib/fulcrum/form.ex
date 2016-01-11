defmodule Fulcrum.Form do
  @derive [Poison.Encoder]
  defstruct [:id, :name, :description, :elements]

end
