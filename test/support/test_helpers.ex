defmodule ContentSecurityPolicy.TestHelpers do
  @moduledoc """
  Contains helper functions for testing `ContentSecurityPolicy` internally.
  """

  alias ContentSecurityPolicy.Directive
  alias ContentSecurityPolicy.Policy

  @valid_directives Policy.__struct__()
                    |> Map.keys()
                    |> Enum.reject(&(&1 == :__struct__))

  @doc """
  Returns a list of all valid directives.
  """
  @spec valid_directives() :: list(Directive.valid_directive())
  def valid_directives, do: @valid_directives

  @doc """
  Provides a stream of invalid directive atoms for use in property tests.
  """
  def invalid_directive_generator do
    StreamData.term()
    |> StreamData.filter(&(&1 not in valid_directives()))
  end

  @doc """
  Provides a non empty list of valid directives with no duplicates for use in
  property tests.
  """
  def list_of_valid_directives_generator do
    valid_directives()
    |> StreamData.member_of
    |> StreamData.list_of(
      min_length: 1,
      max_length: length(valid_directives())
    )
  end
end
