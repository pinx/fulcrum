defmodule Fulcrum.Mixfile do
  use Mix.Project

  def project do
    [app: :fulcrum,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [
      :httpoison,
      :poison,
      :meck,
      :logger]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:poison, "~> 1.5"},
      {:meck, "~> 0.8", only: :test},
      {:exvcr, "~> 0.7", only: :test}
    ]
  end

  defp description do
    """
    Fulcrum library for Elixir.
    The aim is to present the Fulcrum API as a replacement for an Ecto Repo.
    So, instead of Repo.all(Form), you can write Fulcrum.all(Form).
    In this way, you only have to make minor changes to your controllers, to work with Fulcrum.
    """
  end

  defp package do
    [# These are the default files included in the package
     files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: ["Marcel van Pinxteren"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/pinx/fulcrum"}]
  end
end
