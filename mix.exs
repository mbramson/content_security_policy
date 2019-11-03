defmodule ContentSecurityPolicy.MixProject do
  use Mix.Project

  def project do
    [
      app: :content_security_policy,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false},
      {:plug, "~> 1.1"},
      {:order_invariant_compare, "~> 1.0.0", only: :test},
      {:stream_data, ">= 0.0.0", only: :test},
    ]
  end

end
