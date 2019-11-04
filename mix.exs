defmodule ContentSecurityPolicy.MixProject do
  use Mix.Project

  def project do
    [
      app: :content_security_policy,
      version: "1.0.0",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      name: "ContentSecurityPolicy",
      source_url: "https://github.com/mbramson/content_security_policy"
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
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false},
      {:plug, "~> 1.1"},
      {:order_invariant_compare, "~> 1.0.0", only: :test},
      {:stream_data, ">= 0.0.0", only: :test},
    ]
  end

  defp description do
    """
    ContentSecurityPolicy makes working with the `"Content-Security-Policy"`
    response header simple.
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Mathew Bramson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mbramson/content_security_policy"}
    ]
  end

  defp docs do
    [main: "getting-started",
     formatter_opts: [gfm: true],
     source_url: "https://github.com/mbramson/content_security_policy",
     extras: [
       "docs/Getting Started.md"
    ]]
  end
end
