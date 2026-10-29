class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "1041e16b220e550190493050ac1bf595c97c9be9d57c27d0f10c8cf02e7f1e18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9da27a2d6e031b511f420c041ac43f7d9c7e7b89e71b393b5c5b06e3ad9403e"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  deny_network_access!

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
