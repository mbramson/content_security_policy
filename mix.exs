defmodule ContentSecurityPolicy.MixProject do
  use Mix.Project

  def project do
    [
      app: :content_security_policy,
      version: "0.1.0",
      elixir: "~> 1.7",
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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false},
      {:order_invariant_compare, "~> 1.0.0", only: :test},
      {:stream_data, ">= 0.0.0"},
    ]
  end
end
