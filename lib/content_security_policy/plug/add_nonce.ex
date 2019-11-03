defmodule ContentSecurityPolicy.Plug.AddNonce do
  @moduledoc """
  Plug which adds a random nonce to the content security policy. Sets this
  nonce in `Plug.assigns` under the `csp_nonce` key.
  """
  import Plug.Conn

  alias ContentSecurityPolicy.Directive
  alias ContentSecurityPolicy.Policy

  def init(opts) do
    opts
  end

  @default_directives [:default_src]
  @default_byte_size 32

  def call(conn, opts) do
    directives = Keyword.get(opts, :directives, @default_directives)
    bytes = Keyword.get(opts, :byte_size, @default_byte_size)

    nonce = ContentSecurityPolicy.generate_nonce(bytes)
    nonce_source_value = "'nonce-#{nonce}'"

    existing_policy = get_policy!(conn)

    updated_policy = Enum.reduce(directives, existing_policy, fn directive, policy ->
      Directive.validate_directive!(directive)
      ContentSecurityPolicy.add_source_value(policy, directive, nonce_source_value)
    end)

    conn
    |> put_private(:content_security_policy, updated_policy)
    |> assign(:csp_nonce, nonce)
  end

  defp get_policy!(%{private: %{content_security_policy: %Policy{} = policy}}) do
    policy
  end

  defp get_policy!(_) do
    raise """
    Attempted to add a nonce to content security policy, but the content
    security policy was not initialized.

    Please make sure that the `ContentSecurityPolicy.Plug.Setup` plug is run
    before the `ContentSecurityPolicy.Plug.AddNonce` plug.
    """
  end
end
