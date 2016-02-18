defmodule Fulcrum.Form do
  # @derive [Poison.Encoder]
  defstruct name:  nil,
    elements: nil,
    id: nil,
    description: nil,
    bounding_box: nil,
    record_title_key: nil,
    title_field_keys: nil,
    status_field: nil,
    auto_assign: false,
    record_count: 0,
    created_at: nil,
    updated_at: nil,
    memberships: nil,
    image: nil,
    image_thumbnail: nil,
    image_small: nil,
    image_large: nil
end

