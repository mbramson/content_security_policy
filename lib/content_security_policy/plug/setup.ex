defmodule ContentSecurityPolicy.Plug.Setup do
  @moduledoc """
  Plug that sets the default policy and ensures that the proper
  `"content-security-policy"` header is set before the response is sent.

  This `Plug` also registers a `before_send` action that serializes the
  `ContentSecurityPolicy.Policy` struct and inserts the result into the
  `"content-security-policy"` header of the response.
  """

  import Plug.Conn

  alias ContentSecurityPolicy.Policy

  def init(opts) do
    opts
  end

  @default_policy %Policy{default_src: ["'self'"]}

  def call(conn, opts) do
    generate_random_nonce = Keyword.get(opts, :generate_random_nonce, false)
    policy = Keyword.get(opts, :default_policy, @default_policy)

    conn = put_private(conn, :content_security_policy, policy)

    register_before_send(conn, fn conn ->
      policy_before_send = conn.private[:content_security_policy]
      serialized_policy = ContentSecurityPolicy.serialize(policy_before_send) 

      put_resp_header(conn, "content-security-policy", serialized_policy)
    end)
  end
end
