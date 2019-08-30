defmodule ContentSecurityPolicy.Policy do
  @moduledoc """
  Defines the `ContentSecurityPolicy.Policy` struct which represents a given
  Content Security Policy.

  This struct is intended to be a programattic representation of a policy which
  will need to be serialized to a valid content security policy before the
  browser can understand it.
  """

  defstruct default_src: nil,
    font_src: nil,
    frame_src: nil,
    media_src: nil,
    script_src: nil,
    style_src: nil,
    img_src: nil
end
