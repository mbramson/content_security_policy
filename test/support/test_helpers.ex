defmodule ContentSecurityPolicy.TestHelpers do
  @moduledoc """
  Contains helper functions for testing `ContentSecurityPolicy` internally.
  """

  alias ContentSecurityPolicy.Policy

  @valid_directives Policy.__struct__() 
                    |> Map.keys() 
                    |> Enum.reject(&(&1 == :__struct__))

  def valid_directives(), do: @valid_directives
end
