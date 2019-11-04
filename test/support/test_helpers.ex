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
  Provides a stream of valid directive atoms for use in property tests.
  """
  def valid_directive_generator do
    StreamData.member_of(valid_directives())
  end

  @doc """
  Provides a non empty list of valid directives with no duplicates for use in
  property tests.
  """
  def list_of_valid_directives_generator do
    StreamData.list_of(
      valid_directive_generator(),
      min_length: 1,
      max_length: length(valid_directives())
    )
  end

  @doc """
  Provides a stream of valid directives with source value pairs as tuples of the
  format `{directive, source_value}`.
  """
  def valid_directive_source_value_pair_generator do
    StreamData.bind(valid_directive_generator(), fn directive ->
      StreamData.bind(StreamData.string(:printable), fn source_value ->
        StreamData.constant({directive, source_value})
      end)
    end)
  end

  @doc """
  Provides a stream of lists of valid directives with source value pairs as
  tuples of the format `{directive, source_value}`.
  """
  def list_of_valid_directive_source_value_pairs_generator do
    StreamData.list_of(
      valid_directive_source_value_pair_generator(),
      min_length: 1,
      max_length: 10
    )
  end
end
