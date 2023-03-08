# Getting Started

## Description

`ContentSecurityPolicy` makes working with the `"Content-Security-Policy"`
response header simple.

The `"Content-Security-Policy"` header is a header that restricts how a browser
can receive resources such as images and scripts. It's intent is to improve
security by making it more difficult for an attacker to get the browser to run
an arbitrary thing.

## Installation

The package can be installed by adding `content_security_policy` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:content_security_policy, "~> 1.0"}
  ]
end
```

## Why use this?

Using a `"Content-Security-Policy"` header is a great way to improve the
security of a web application that serves HTML to a browser. It allows the
specification of exactly which resources are allowed to be loaded and how.

The `"Content-Security-Policy"` header can specify, for example, that only
scripts from either the application's server or google.com which are retrieved
using https should be allowed. If an attacker were somehow able to inject a
script and get it to run, the browser would consult the
`"Content-Security-Policy"` header and then deny that script from running. This
makes it much harder for Cross-Site Scripting (XSS) attacks to succeed.

If you've used [`sobelow`](https://hexdocs.pm/sobelow/readme.html), with a
default `Phoenix` project, you may have noticed a warning telling you something
about a Content Security Policy. This project aims to make it extremely easy to
deal with that warning.

Another strength of this project is that it makes dealing with Content Security
Policy nonces simple. Nonces are a way of telling the browser that a specific
resource is okay when the server might otherwise not know how to describe that
resource via CSP. A good example of this is a dynamically generated QR Code.
Although it's possible to calculate the SHA hash of the QR code, it's often
easier to use a nonce and call it a day. For more on this use case check out
the documentation in the `ContentSecurityPolicy.Plug.AddNonce` plug.

## Content Security Policy Terminology

There are many functions and modules which reference terminology of Content
Security Policies. It's probably a good idea to define this terminology, so
here goes.

Let's take an example content security policy header:
```
content-security-policy: default-src https: 'self'; img-src https://imgur.com;
```

That whole thing is known as the **Content Security Policy Response Header**.

The contents of that (`default-src https: 'self'; img-src https://imgur.com;`)
are referred to as the **Content Security Policy** or simply **Policy**.

That policy contains two **Directives** (`default-src` and `img-src`).

Each Directive contains a number of **Source Values**. The `default-src`
directive contains the `https:` and `'self'` source values. The `img-src`
directive contains the `https://imgur.com` source value.

## How does it work?

If we just want to set one Content Security Policy we can just add the
following plug to our Router (in the appropriate pipeline or place, of course).

```elixir
plug(ContentSecurityPolicy.Plug.Setup,
  default_policy: %ContentSecurityPolicy.Policy{
    default_src: ["https:", "'self'"],
    img_src: ["*.imgur.com"]
  }
)
```

The above plug sets the content security policy struct to whatever is passed
in. This is assigned to `conn.private.content_security_policy`.

It also sets up a `before_send` action which serializes that value to a string
that the browser understands and stuffs it into the `"content-security-policy"`
header right before the response is sent. This means we can modify the content
security policy in `conn.private.content_security_policy` all we want and it'll
only ever be serialized once.

### Adding a Source Value to a Directive

If a specific page has a resource that other pages do not, it is possible to
add that specific source value to a directive for that controller function
only. This means that you can get a bit more granular than simply setting a
global content security policy that references resources that are only
retrieved in very specific isntances.

For more on this see the `ContentSecurityPolicy.Plug.AddSourceValue` module
documentation.

### Nonces

The `ContentSecurityPolicy.Plug.AddNonce` plug makes working with nonces easy.
For more on this functionality, check out the module documentation in
`ContentSecurityPolicy.Plug.AddNonce`.

### Accessing Lower Level Functionality

The `ContentSecurityPolicy` module contains all of the functions you might need
if you want to interact with Content Security Policies at a lower level. The
plugs provided with this project should make this unnecessary... but if you
need this, it's there!
