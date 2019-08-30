defmodule ContentSecurityPolicyTest do
  use ExUnit.Case
  doctest ContentSecurityPolicy

  alias ContentSecurityPolicy.Policy
  alias ContentSecurityPolicy, as: CSP

  describe "serialize/1" do
    test "serializes one directive with one source value" do
      policy = %Policy{default_src: ["'self'"]}
      assert CSP.serialize(policy) == "default-src 'self';"
    end
  end

end
