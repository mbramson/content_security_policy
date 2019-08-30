defmodule ContentSecurityPolicyTest do
  use ExUnit.Case
  doctest ContentSecurityPolicy

  test "greets the world" do
    assert ContentSecurityPolicy.hello() == :world
  end
end
