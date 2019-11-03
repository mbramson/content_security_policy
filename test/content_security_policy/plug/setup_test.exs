defmodule ContentSecurityPolicy.Plug.SetupTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ContentSecurityPolicy.Policy

  defp send_response(setup_plug_opts \\ []) do
    :post
    |> conn("/foo")
    |> ContentSecurityPolicy.Plug.Setup.call(setup_plug_opts)
    |> send_resp(200, "ok")
  end

  describe "call/2" do
    test "adds a Content-Security_Policy response header" do
      conn = send_response()

      assert get_resp_header(conn, "content-security-policy") ==
        ["default-src 'self';"]
    end

    test "adds a set default content security policy header" do
      default_policy = %Policy{default_src: ["'self'", "https:"]}
      conn = send_response([default_policy: default_policy])

      assert get_resp_header(conn, "content-security-policy") ==
        ["default-src 'self' https:;"]
    end
  end
end
