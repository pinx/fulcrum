defmodule Fulcrum.FormMembershipTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Fulcrum.FormMembership

  setup_all do
    HTTPoison.start
  end

  test "insert!/1" do
    use_cassette "form_memberships#create" do
      form_id = "50902d3b-f79a-447c-8327-622d9d354e3e"
      membership_id = "9ba3dea3-8edb-4137-92dd-f27d12adfc76"
      memberships = Fulcrum.insert!(%FormMembership{form_id: form_id, membership_id: membership_id})
      assert Enum.count(memberships) == 1
    end
  end

end
