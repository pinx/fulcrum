defmodule Fulcrum.MembershipTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Fulcrum.Membership

  setup_all do
    HTTPoison.start
  end

  test "all/1" do
    use_cassette "memberships#all" do
      memberships = Fulcrum.all(Membership)
      assert Enum.count(memberships) > 0
    end
  end

end
