defmodule ContentSecurityPolicy.Directive do
  @moduledoc """
  Contains functions useful for interacting with Content Security Policy directives.

  Directives are the keys in a content secrurity which define the scope of what
  the source values apply to.

  As an example, in the policy of `"default-src 'self'"`, `default-src` is the
  directive.
  """

  alias ContentSecurityPolicy.Policy

  @valid_directives Policy.__struct__()
                    |> Map.keys()
                    |> Enum.reject(&(&1 == :__struct__))

  @doc """
  Validates a given directive. Used by other functions in
  `ContentSecurityPolicy`.

  Raises an `ArgumentError` if the directive is not valid.
  """
  @spec validate_directive!(atom()) :: :ok | no_return()
  def validate_directive!(:child_src), do: :ok
  def validate_directive!(:connect_src), do: :ok
  def validate_directive!(:default_src), do: :ok
  def validate_directive!(:font_src), do: :ok
  def validate_directive!(:form_action), do: :ok
  def validate_directive!(:frame_ancestors), do: :ok
  def validate_directive!(:frame_src), do: :ok
  def validate_directive!(:img_src), do: :ok
  def validate_directive!(:media_src), do: :ok
  def validate_directive!(:object_src), do: :ok
  def validate_directive!(:plugin_types), do: :ok
  def validate_directive!(:report_uri), do: :ok
  def validate_directive!(:sandbox), do: :ok
  def validate_directive!(:script_src), do: :ok
  def validate_directive!(:style_src), do: :ok

  def validate_directive!(directive) do
    raise ArgumentError, """
    Invalid directive (#{inspect(directive)}).

    Directive must be one of the following directives: #{inspect(@valid_directives)}
    """
  end
end
