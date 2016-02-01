defmodule Fulcrum.Record do
  @derive [Poison.Encoder]
  defstruct [
    :form_id,
    :latitude,
    :longitude,
    :form_values,
    :status,
    :version,
    :id,
    :created_at,
    :updated_at,
    :client_created_at,
    :client_updated_at,
    :created_by,
    :created_by_id,
    :updated_by,
    :updated_by_id,
    :project_id,
    :assigned_to,
    :assigned_to_id,
    :altitude,
    :speed,
    :course,
    :horizontal_accuracy,
    :vertical_accuracy
  ]

end
