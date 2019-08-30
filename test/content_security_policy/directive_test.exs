defmodule ContentSecurityPolicy.DirectiveTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias ContentSecurityPolicy.Directive
  alias ContentSecurityPolicy.Policy

  @valid_directives Policy.__struct__() 
                    |> Map.keys() 
                    |> Enum.reject(&(&1 == :__struct__))

  describe "validate_directive!/1" do
    property "returns :ok for all keys of the Property struct" do
      Enum.each(@valid_directives, fn directive ->
        assert Directive.validate_directive!(directive) == :ok
      end)
    end

    defp invalid_directive_generator() do
      StreamData.term()
      |> StreamData.filter(&(&1 not in @valid_directives))
    end

    property "raises an ArgumentError for any invalid directive" do
      check all value <- invalid_directive_generator() do
        assert_raise(ArgumentError, ~r/Invalid directive/, fn ->
          Directive.validate_directive!(value)
        end)
      end
    end
  end

end
