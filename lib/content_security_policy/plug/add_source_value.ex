defmodule ContentSecurityPolicy.Plug.AddSourceValue do
  @moduledoc """
  Plug which adds a source value to the given directive.

  This plug must be run after the `ContentSecurityPolicy.Setup` plug, or it
  will raise an exception.

  ## Example Usage

  In a controller or router:

      plug ContentSecurityPolicy.Setup
      plug ContentSecurityPolicy.AddSourceValue, 
        script_src: "https://google.com"

  When the response is sent to the browser, the `"content-security-policy"`
  response header will contain `"script-src https://google.com"` directive.

  Multiple directives and source values can be provided in the same call.

      plug ContentSecurityPolicy.AddSourceValue, 
        script_src: "'self'", 
        script_src: "https://google.com"

  When the response is sent to the browser, the `"content-security-policy"`
  response header will contain `"script-src 'self' https://google.com"`
  directive.

  The `ContentSecurityPolicy.Plug.AddSourceValue` plug is additive. It will
  never replace or remove old source values associated with a directive.

  """
  import Plug.Conn

  alias ContentSecurityPolicy.Directive
  alias ContentSecurityPolicy.Policy

  def init([]), do: raise_no_arguments_error()
  def init(opts) do
    Enum.each(opts, fn {directive, _source_value} ->
      Directive.validate_directive!(directive)
    end)

    opts
  end

  def call(conn, []), do: raise_no_arguments_error()
  def call(conn, opts) do
    existing_policy = get_policy!(conn)

    updated_policy =
      Enum.reduce(opts, existing_policy, fn {directive, source_value}, policy ->
        ContentSecurityPolicy.add_source_value(policy, directive, source_value)
      end)

    put_private(conn, :content_security_policy, updated_policy)
  end

  defp get_policy!(%{private: %{content_security_policy: %Policy{} = policy}}) do
    policy
  end

  defp get_policy!(_) do
    raise """
    Attempted to add a source value to the content security policy, but the
    content security policy was not initialized.

    Please make sure that the `ContentSecurityPolicy.Plug.Setup` plug is run
    before the `ContentSecurityPolicy.Plug.AddSourceValue` plug.
    """
  end

  defp raise_no_arguments_error do
    raise ArgumentError, """
    No directive and source value supplied to the
    `ContentSecurityPolicy.Plug.AddSourceValue` plug.
    """
  end
end
