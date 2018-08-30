defmodule Ethereum.MixProject do
  use Mix.Project

  def project do
    [
      app: :ethereum,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ethereum.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # Ethereum official repos
      {:ex_rlp, "~> 0.3.0"},
      {:merkle_patricia_tree, "~> 0.2.7"},
      # {:keccakf1600, "~> 2.0.0"},
      {:rox, "~> 2.0"}

      # ArcBlock repos
      # {:ocap_rpc, git: "https://github.com/ArcBlock/ocap-rpc.git", tag: "master"}
    ]
  end
end
