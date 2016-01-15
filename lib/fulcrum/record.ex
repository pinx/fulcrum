defmodule Fulcrum.Record do
  @derive [Poison.Encoder]
  defstruct [:id, :form_id, :project_id, :form_values]

end
