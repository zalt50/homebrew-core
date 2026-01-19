class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3230d86f5d98eab85b220dd1a3892907bd8b00da3b792a75a32c0a077b138188"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd10315ee1862bf1937f6a7f897a3686930478b5c1fe396872a9f8f0e55843c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd10315ee1862bf1937f6a7f897a3686930478b5c1fe396872a9f8f0e55843c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd10315ee1862bf1937f6a7f897a3686930478b5c1fe396872a9f8f0e55843c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "20bfdf0f67e2ab1f5c4cd5b2691b7046e3d8b7e94f7a0c8c94983c9858354faf"
  end

  depends_on :macos

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
