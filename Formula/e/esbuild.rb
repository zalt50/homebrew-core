class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a4fd2af11353d41999b51bfa4276cbdd562b5f5fc19b3ca56ab69a520b176529"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25bad36a6cba7a7e127a56ff12c647af2f8b4349221240cc1aaa43616ea4b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25bad36a6cba7a7e127a56ff12c647af2f8b4349221240cc1aaa43616ea4b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25bad36a6cba7a7e127a56ff12c647af2f8b4349221240cc1aaa43616ea4b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "35747a0816b3b4f6f4740f2e04adf14fa76075ba1b7e619ea1af9391db59f046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b7a6f631d8ec8190448c4c2d79da0ef6991c2ad91f35be649decbae88702453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07ece8829bc11ed22ff7db5c446adaaf979f3994417a9ef5536354bea7d11f5"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
