defmodule ContentSecurityPolicy do
  @moduledoc """
  Provides functions for interacting with Content Security Policies.

  A Content Security Policy is a header which determines which assets the
  browser is allowed to retrieve.

  See https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP for more in depth
  documentation.
  """

  alias ContentSecurityPolicy.Directive
  alias ContentSecurityPolicy.Policy

  @doc """
  Converts a `ContentSecurityPolicy.Policy` struct to a valid content security
  policy string.

  ## Examples

      iex> policy = %ContentSecurityPolicy.Policy{default_src: ["'self'"]}
      iex> ContentSecurityPolicy.serialize(policy)
      "default-src 'self';"

  """
  def serialize(%Policy{} = csp) do
    csp
    |> Map.from_struct()
    |> filter_empty_sources
    |> stringify_and_hyphenate_directives
    |> join_sources_with_spaces
    |> format_each_directive
    |> join_directives_with_spaces
  end

  defp filter_empty_sources(policy) do
    Enum.reject(policy, fn {_directive, source} -> is_empty(source) end)
  end

  defp is_empty(nil), do: true
  defp is_empty([]), do: true
  defp is_empty(""), do: true
  defp is_empty(_), do: false

  defp stringify_and_hyphenate_directives(policy) do
    Enum.map(policy, fn {directive, source} ->
      updated_directive =
        directive
        |> to_string
        |> String.replace("_", "-")

      {updated_directive, source}
    end)
  end

  defp join_sources_with_spaces(policy) do
    Enum.map(policy, fn {directive, sources} -> {directive, Enum.join(sources, " ")} end)
  end

  defp format_each_directive(policy) do
    Enum.map(policy, fn {directive, sources} -> "#{directive} #{sources};" end)
  end

  defp join_directives_with_spaces(directives) when is_list(directives) do
    Enum.join(directives, " ")
  end

  @doc """
  Adds a single source value to a directive on the given policy.
  """
  @spec add_source_value(Policy.t(), atom(), String.t()) :: Policy.t()
  def add_source_value(policy, directive, source_value) do
    Directive.validate_directive!(directive)

    current_source_values = Map.get(policy, directive) || []
    new_source_values = current_source_values ++ [source_value]
    Map.put(policy, directive, new_source_values)
  end

  @doc """
  Generates a random base 64 encoded string for use in Content Security Policy
  nonces.
  """
  @spec generate_nonce(bytes :: pos_integer()) :: String.t()
  def generate_nonce(bytes \\ 32) do
    bytes
    |> :crypto.strong_rand_bytes
    |> Base.encode64(padding: false)
  end
end
