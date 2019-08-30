defmodule ContentSecurityPolicy do
  @moduledoc """
  Provides functions for interacting with Content Security Policies.

  A Content Security Policy is a header which determines which assets the
  browser is allowed to retrieve.

  See https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP for more in depth
  documentation.
  """

  alias ContentSecurityPolicy.Policy

  def serialize(%Policy{} = csp) do
    csp
    |> Map.from_struct()
    |> stringify_and_hyphenate_directives
    |> Enum.reject(fn {_directive, sources} -> is_nil(sources) end)
    |> Enum.map(fn {directive, sources} -> {directive, Enum.join(sources, " ")} end)
    |> Enum.map(fn {directive, sources} -> "#{directive} #{sources};" end)
    |> Enum.join(" ")
  end

  defp stringify_and_hyphenate_directives(policy) when is_map(policy) do
    Enum.map(policy, fn {directive, source} ->
      updated_directive =
        directive
        |> to_string
        |> String.replace("_", "-")

      {updated_directive, source}
    end)
  end
end
