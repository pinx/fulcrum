defmodule Fulcrum.FormTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Fulcrum.Form

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
end
