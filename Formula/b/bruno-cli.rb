class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.0.0.tgz"
  sha256 "8688d9827112de5acda5982e2e1e7e726ecde3d63c2ca2926e154479fc84e3ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d49c5cce7c8887f0bddcb16362ff44f5cce388764a57c12efcbf91c053badb98"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end
