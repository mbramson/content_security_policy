defmodule ContentSecurityPolicyTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  doctest ContentSecurityPolicy

  alias ContentSecurityPolicy, as: CSP
  alias ContentSecurityPolicy.Policy

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

  describe "generate_nonce/1" do
    property "outputs a base 64 encoded string of `bytes` length" do
      check all bytes <- integer(1..1000) do
        base64_encoded_nonce = CSP.generate_nonce(bytes)

        assert {:ok, decoded_nonce} =
          Base.decode64(base64_encoded_nonce, padding: false)

        assert byte_size(decoded_nonce) == bytes
      end
    end
  end
end
