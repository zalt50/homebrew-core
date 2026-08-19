class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "b4e92a981a393963108a429da8396aa2b8165c01ddad0004c8be435d85f83c27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e545a56b0f230944ca22b16196c85d91de89728cb58158a31c2ecb6aec880df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e545a56b0f230944ca22b16196c85d91de89728cb58158a31c2ecb6aec880df3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e545a56b0f230944ca22b16196c85d91de89728cb58158a31c2ecb6aec880df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c2e79050b8d21715c08e185d533784ae7c0dc0833a2fbf71c13c0298ad0f965"
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
