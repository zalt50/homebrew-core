class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.0.tgz"
  sha256 "4c8c382631a64f819cfe4f1e69f4739f72e1903bfd8a4d236c28feb30a45a721"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a96451c09c49cc8f16898bb90b93b5d19df064c6ef540f0d2f1e7e1263d80444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96451c09c49cc8f16898bb90b93b5d19df064c6ef540f0d2f1e7e1263d80444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96451c09c49cc8f16898bb90b93b5d19df064c6ef540f0d2f1e7e1263d80444"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b07d4a4497b6816ccd4260f994ec4ab53335084700c8d387a9ea2889821364"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c5ad97b54dff1e71815b208f0b289774d321c0853cdb1ffcb2b253b049163bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28279b1fed5b5f2d59adf0a7364f4ceecfb6830334f08be01d8075266208c39"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
