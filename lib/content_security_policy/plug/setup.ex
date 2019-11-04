defmodule ContentSecurityPolicy.Plug.Setup do
  @moduledoc """
  Plug that sets the default policy and ensures that the proper
  `"content-security-policy"` header is set before the response is sent.

  This `Plug` registers a `before_send` action that serializes the
  `ContentSecurityPolicy.Policy` struct and inserts the result into the
  `"content-security-policy"` header of the response.

  ## Example Usage
  
  In a controller or router: 

      plug ContentSecurityPolicy.Plug.Setup(
        default_policy: %ContentSecurityPolicy.Policy{
          default_src: ["https:", "'self'"],
          img_src: ["*.imgur.com"]
        }
      )


  The above plug sets the content security policy struct to whatever is passed
  in. This is assigned to `conn.private.content_security_policy`.

  Before the response is sent, this policy will be serialized into a content
  security policy that the browser understands.

  In the case of the above, the following response header will be sent:
  `content-security-policy: default-src https: 'self'; img-src *.imgur.com`
  """

  import Plug.Conn

  alias ContentSecurityPolicy.Policy

  def init(opts) do
    opts
  end

  @default_policy %Policy{default_src: ["'self'"]}

  def call(conn, opts) do
    policy = Keyword.get(opts, :default_policy, @default_policy)

    conn = put_private(conn, :content_security_policy, policy)

    register_before_send(conn, fn conn ->
      policy_before_send = conn.private[:content_security_policy]
      serialized_policy = ContentSecurityPolicy.serialize(policy_before_send)

      put_resp_header(conn, "content-security-policy", serialized_policy)
    end)
  end
end
