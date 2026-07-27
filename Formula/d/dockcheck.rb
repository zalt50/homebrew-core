class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://mag37.org"
  url "https://github.com/mag37/dockcheck/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "5968ebcef52e4d84b2b93daf6f0a0174e4f3c31d93d0d076aef0af532a4343a1"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b490864ef7db4b142de27da5481d46a05d627a22d840a27f0141016867803c0"
  end

  depends_on "regclient"

  uses_from_macos "jq", since: :sequoia

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "user does not have permissions to the docker socket", output
  end
end
