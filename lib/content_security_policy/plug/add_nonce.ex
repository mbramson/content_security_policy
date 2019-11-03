defmodule ContentSecurityPolicy.Plug.AddNonce do
  @moduledoc """
  Plug which adds a random nonce to the content security policy. Sets this
  nonce in `Plug.assigns` under the `csp_nonce` key.

  ## Example Usage

  In a controller or router:

      plug ContentSecurityPolicy.Setup
      plug ContentSecurityPolicy.AddNonce directives: [:script_src]

  The nonce is then added to the `script-src` directive and will be sent in the
  "content-security-policy" response header. To access this nonce value when
  rendering a response, check `conn.assigns[:csp_nonce]`.

      conn.assigns[:csp_nonce]
      "EDNnf03nceIOfn39fn3e9h3sdfa"

  If using `.eex` templates to render a response, that might look something
  like:

      <script nonce="<%= @conn.assigns[:csp_nonce] %>">
        ... #JavaScript I'd like to be allowed
      </script>

  When that response is sent to the browser, the `"content-security-policy"`
  response header will contain `"script-src
  'nonce-EDNnf03nceIOfn39fn3e9h3sdfa'"`, which should cause the browser to
  whitelist this specific script.

  Note that the nonce is randomly generated for every single request, which
  ensures that an attacker can't just guess your nonce and get their malicious
  script/resource run.
  """
  import Plug.Conn

  alias ContentSecurityPolicy.Directive
  alias ContentSecurityPolicy.Policy

  @default_directives [:default_src]
  @default_byte_size 32

  def init(opts) do
    directives = Keyword.get(opts, :directives, @default_directives)
    Enum.each(directives, fn directive ->
      Directive.validate_directive!(directive)
    end)

    opts
  end

  def call(conn, opts) do
    directives = opts
                 |> Keyword.get(:directives, @default_directives)
                 |> Enum.uniq

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
