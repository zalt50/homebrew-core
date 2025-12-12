class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://github.com/mag37/dockcheck"
  url "https://github.com/mag37/dockcheck/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "d0de676c0a65134b1b77629b7b1d641018a9c38963387db2d825b748a2ed11b7"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8148932c3cea54efaaf09836bb67bc9689f03fa3b036fa5a7f0e9a9cda520c4"
  end

  depends_on "jq"
  depends_on "regclient"

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "user does not have permissions to the docker socket", output
  end
end
