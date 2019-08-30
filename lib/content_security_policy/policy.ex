defmodule ContentSecurityPolicy.Policy do
  @moduledoc """
  Defines the `ContentSecurityPolicy.Policy` struct which represents a given
  Content Security Policy.

  This struct is intended to be a programattic representation of a policy which
  will need to be serialized to a valid content security policy before the
  browser can understand it.
  """

  defstruct "default-src": nil,
    "font-src": nil,
    "frame-src": nil,
    "media-src": nil,
    "script-src": nil,
    "style-src": nil,
    "img-src": nil
end
