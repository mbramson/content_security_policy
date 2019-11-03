defmodule ContentSecurityPolicy.Policy do
  @moduledoc """
  Defines the `ContentSecurityPolicy.Policy` struct which represents a given
  Content Security Policy.

  This struct is intended to be a programattic representation of a policy which
  will need to be serialized to a valid content security policy before the
  browser can understand it.
  """

  alias ContentSecurityPolicy.Policy

  @type t :: %Policy{}

  defstruct child_src: nil,
    connect_src: nil,
    default_src: nil,
    font_src: nil,
    form_action: nil,
    frame_ancestors: nil,
    frame_src: nil,
    img_src: nil,
    media_src: nil,
    object_src: nil,
    plugin_types: nil,
    report_uri: nil,
    sandbox: nil,
    script_src: nil,
    style_src: nil

end
