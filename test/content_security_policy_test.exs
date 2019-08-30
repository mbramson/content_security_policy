defmodule ContentSecurityPolicyTest do
  use ExUnit.Case
  doctest ContentSecurityPolicy

  alias ContentSecurityPolicy.Policy
  alias ContentSecurityPolicy, as: CSP

  import OrderInvariantCompare

  describe "serialize/1" do
    test "serializes one directive with one source value" do
      policy = %Policy{default_src: ["'self'"]}
      assert CSP.serialize(policy) == "default-src 'self';"
    end
  end

  describe "add_source_value/3" do
    test "adds a source value to the given directive" do
      policy = %Policy{default_src: ["'self'"]}
      new_policy = CSP.add_source_value(policy, :default_src, "https:")
      new_source_values = new_policy.default_src
      assert new_source_values <~> ["https:", "'self'"]
    end

    test "can add a source value to an empty directive" do
      policy = %Policy{default_src: nil}
      new_policy = CSP.add_source_value(policy, :default_src, "https:")
      assert new_policy.default_src == ["https:"]

      policy = %Policy{default_src: []}
      new_policy = CSP.add_source_value(policy, :default_src, "https:")
      assert new_policy.default_src == ["https:"]
    end
  end
end
