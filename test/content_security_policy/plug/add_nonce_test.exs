defmodule ContentSecurityPolicy.Plug.AddNonceTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  use Plug.Test

  alias ContentSecurityPolicy.Plug.AddNonce
  alias ContentSecurityPolicy.Plug.Setup
  alias ContentSecurityPolicy.Policy
  alias ContentSecurityPolicy.TestHelpers

  defp send_response(add_nonce_plug_opts \\ []) do
    :post
    |> conn("/foo")
    |> Setup.call([default_policy: %Policy{}])
    |> AddNonce.call(add_nonce_plug_opts)
    |> send_resp(200, "ok")
  end

  describe "call/2" do
    test "adds a nonce to the default_src directive by default" do
      conn = send_response()

      csp_nonce = conn.assigns[:csp_nonce]

      refute csp_nonce == nil
      assert get_resp_header(conn, "content-security-policy") ==
        ["default-src 'nonce-#{csp_nonce}';"]
    end

    property "can add a nonce to any number of valid directives" do
      check all directives <- TestHelpers.list_of_valid_directives_generator() do
        conn = send_response(directives: directives)

        csp_nonce = conn.assigns[:csp_nonce]
        refute csp_nonce == nil

        assert [csp_header] = get_resp_header(conn, "content-security-policy")

        Enum.each(directives, fn directive_atom ->
          directive = directive_atom |> to_string |> String.replace("_", "-")
          expected_directive_in_header = "#{directive} 'nonce-#{csp_nonce}';"
          assert csp_header =~ expected_directive_in_header
        end)
      end
    end

    test "succeeds when directives list is empty" do
      conn = send_response(directives: [])

      # Generate a nonce anyway. Why not?
      csp_nonce = conn.assigns[:csp_nonce]
      refute csp_nonce == nil

      assert [""] = get_resp_header(conn, "content-security-policy")
    end

    test "errors when given an invalid directive" do
      assert_raise(ArgumentError, ~r/Invalid directive/, fn ->
        send_response(directives: [:not_a_directive])
      end)
    end
  end
end
