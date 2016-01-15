defmodule Fulcrum.RecordTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Fulcrum.Record

  doctest Fulcrum.Record

  setup_all do
    HTTPoison.start
  end

  test "all/1" do
    use_cassette "record#all" do
      records = Fulcrum.all(Record)
      assert Enum.count(records) > 0
    end
  end

  test "get!/1" do
    use_cassette "records#get" do
      record = Fulcrum.get!(Record, "7611ba4e-ccdb-4d66-96ad-306c526468d3")
      assert String.length(record.form_id) > 0
    end
  end

  test "insert!/1" do
    use_cassette "records#insert" do
      record = %Record{
        form_id: "03e616bd-d6e6-4973-84e3-a3ed805407e3",
        form_values: %{"628b" => "undefined"}
      }
      record = Fulcrum.insert!(record)
      assert record.form_id == "03e616bd-d6e6-4973-84e3-a3ed805407e3"
    end
  end
end
