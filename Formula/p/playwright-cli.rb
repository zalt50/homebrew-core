class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.22.tgz"
  sha256 "bb4840be17006e2b7ba856224dc3062f6571d5f647352476f95c5e77ff5d679a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f81ca01bd99b7e8a7d36c86adad061872821794d4c0e7e1600bad2fa4e111213"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end
