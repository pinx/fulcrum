defmodule Fulcrum.FormTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Fulcrum.Form

  require Logger

  doctest Fulcrum.Form

  setup_all do
    HTTPoison.start
  end

  test "all/1" do
    use_cassette "forms#all" do
      forms = Fulcrum.all(Form)
      assert Enum.count(forms) > 0
    end
  end

  test "get!/1" do
    use_cassette "forms#get" do
      form = Fulcrum.get!(Form, "e6340e99-9b62-4dc4-850f-6d7724d00b10")
      assert String.length(form.name) > 0
      assert to_string(form.__struct__) =~ ~r/Form$/
    end
  end

  test "insert!/1" do
    use_cassette "forms#insert" do
      form = %Form{name: "TestForm", description: "Test description", elements: [%{
    			type: "TextField",
    			key: "2832",
    			label: "ID Tag",
    			data_name: "id_tag",
    			description: "Enter the asset tag ID.",
    			required: false,
    			disabled: false,
    			hidden: false,
    			default_value: ""
    		}]}
      form = Fulcrum.insert!(form)
      assert form.name == "TestForm"
    end
  end

  test "update!/1" do
    use_cassette "forms#update" do
      form = Fulcrum.get!(Form, "e6340e99-9b62-4dc4-850f-6d7724d00b10")
      form = Map.put(form, :description, "Updated description")
      form = Fulcrum.update!(form)
      assert form.description == "Updated description"
    end
  end

  test "delete!/1" do
    use_cassette "forms#delete" do
      id = "b77aec00-ebca-4b97-b2c9-51728c36061e"
      resp_form = Fulcrum.delete!(Form, id)
      assert resp_form.id == "b77aec00-ebca-4b97-b2c9-51728c36061e"
    end
  end

  test "delete!/2" do
    use_cassette "forms#delete2" do
      id = "b77aec00-ebca-4b97-b2c9-51728c36061e"
      form = Fulcrum.get!(Form, id)
      resp_form = Fulcrum.delete!(form)
      assert resp_form.id == "b77aec00-ebca-4b97-b2c9-51728c36061e"
    end
  end
end
