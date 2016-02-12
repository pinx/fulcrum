defmodule Fulcrum.Membership do
  defstruct [
    :id, 
    :gravatar_email, 
    :gravatar_image_url,
    :user_id,
    :user,
    :email,
    :role_id,
    :created_at,
    :updated_at
  ]
end
