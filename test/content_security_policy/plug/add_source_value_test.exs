defmodule ContentSecurityPolicy.Plug.AddSourceValueTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  use Plug.Test

  alias ContentSecurityPolicy.Plug.AddSourceValue
  alias ContentSecurityPolicy.Plug.Setup
  alias ContentSecurityPolicy.Policy
  alias ContentSecurityPolicy.TestHelpers

  defp send_response(add_source_value_opts) do
    :post
    |> conn("/foo")
    |> Setup.call([default_policy: %Policy{}])
    |> AddSourceValue.call(add_source_value_opts)
    |> send_resp(200, "ok")
  end

  describe "call/2" do
    property "adds source values to corresponding directives" do
      check all valid_directives_with_source_values <- 
        TestHelpers.list_of_valid_directive_source_value_pairs_generator()
      do
        conn = send_response(valid_directives_with_source_values)

        assert [csp_header] = get_resp_header(conn, "content-security-policy")

        Enum.each(valid_directives_with_source_values, fn {directive_atom, source_value} ->
          directive = directive_atom |> to_string |> String.replace("_", "-")
          match = "#{directive} [^;]*#{Regex.escape(source_value)}.*;"
          assert {:ok, regex_for_this_pair} = Regex.compile(match)
          assert csp_header =~ regex_for_this_pair
        end)
      end     
    end

    test "raises an error if given an invalid directive" do
      assert_raise(ArgumentError, ~r/Invalid directive/, fn ->
        conn = send_response(not_a_directive: "doesnt matter")
      end)
    end

    test "raises an error if given no directive source value pairs" do
      assert_raise(ArgumentError, ~r/No directive and source value supplied/, fn ->
        conn = send_response([])
      end)
    end
  end
end
