class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "babf9a1d2a6f899fccba8b39c5d9c836110a75da6f794f440354dc6c07fb8de9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "986881601b83dbfc64a69c3fe44328a3fd4f7de99346a8e0be1ed54ff15f8f0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "986881601b83dbfc64a69c3fe44328a3fd4f7de99346a8e0be1ed54ff15f8f0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "986881601b83dbfc64a69c3fe44328a3fd4f7de99346a8e0be1ed54ff15f8f0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43efc75f33ce42967fbac5b1791b2a0d858fc206456baafa464af93f38e3089d"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
