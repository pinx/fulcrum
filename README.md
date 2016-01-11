# Fulcrum

Fulcrum library for Elixir.

The aim is to present the Fulcrum API as an alternative to the Ecto Repo.

So, instead of Repo.all(Form), you can write Fulcrum.all(Form). In this way, you only have to make minor changes to your controllers, to work with Fulcrum.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add fulcrum to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:fulcrum, "~> 0.0.1"}]
end
```

  2. Ensure fulcrum is started before your application:

```elixir
def application do
  [applications: [:fulcrum]]
end
```

  3. Add your Fulcrum api-key to your config file

```elixir
use Mix.Config
  config :fulcrum,
    api_key: "<your key here>"
```

## Usage

The following resources are available:

  - [ ] Users (only "all")
  - [x] Forms
  - [x] Records
  - [ ] Choice Lists
  - [ ] Classification Sets
  - [ ] Change Sets (coming from mobile device)

The following functions are implemented:
  - [x] all/1
  - [x] get!/1
  - [x] insert!/2
  - [ ] update!/2
  - [ ] delete!/1
