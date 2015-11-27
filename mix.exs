defmodule Relief.Mixfile do
  use Mix.Project

  def project do
    [app: :relief,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    []
  end

  defp description do
    """
     A collection of Elixir Stream oriented relief mechanisms.
    """
  end

  defp package do
    [maintainers: ["Alex Arnell"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/voidlock/relief"}]
  end
end
