defmodule ContentSecurityPolicy.Plug.AddNonceTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ContentSecurityPolicy.Plug.AddNonce
  alias ContentSecurityPolicy.Plug.Setup

  defp send_response(add_nonce_plug_opts \\ []) do
    :post
    |> conn("/foo")
    |> Setup.call([])
    |> AddNonce.call(add_nonce_plug_opts)
    |> send_resp(200, "ok")
  end

  describe "call/2" do
    test "adds a nonce to the default_src directive by default" do
      conn = send_response()

      csp_nonce = conn.assigns[:csp_nonce]

      refute csp_nonce == nil
      assert get_resp_header(conn, "content-security-policy") == 
        ["default-src 'self' 'nonce-#{csp_nonce}';"]
    end
  end
end
