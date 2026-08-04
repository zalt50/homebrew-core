class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "f613c7e1b395a68e696b8f2ed82a0157cae87215b91e429e15c98f5a9662076a"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39960e0c8120a027386c632c80d7aadeaf7925bcdae8fd180c51a50249335efd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d46154f3aa2d77c15ab9eea7445d78ca338372ee13de80645b63c650ea23e681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db618831d29924a1b63115e9afe6ebd7f04d077b1230f9136cfb637b4bef199f"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to create subscription", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
