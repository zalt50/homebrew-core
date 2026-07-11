class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "fc228a40ff270906e4142ba4cf0bcb574b4ac3bfa2e8d2974a5d360b034911c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2691c7b7705a6ac6edd318f4e64fd6ac2904313e7c8cf7447a3a7972c00ffaa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2691c7b7705a6ac6edd318f4e64fd6ac2904313e7c8cf7447a3a7972c00ffaa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2691c7b7705a6ac6edd318f4e64fd6ac2904313e7c8cf7447a3a7972c00ffaa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a4592ba2251cf6605a36687f54610c93f038c661f5e4bbc41abdecce3379492"
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
