class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.4.2.tgz"
  sha256 "f46a10c0d90ea905c00d44e4e1b9e74293d2146836498734f686cf2dc98570b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d5ac3767ff30b04faaeaa0990d485d4ef89a4dac023e2b3e4b5caed3dfb2e63"
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
