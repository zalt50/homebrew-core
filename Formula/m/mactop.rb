class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "af5abc8dff539da7c1d8771327307bd1fac12d4cf768f6696826a49c493a2abf"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c3635ce548446112507a878d84ebf8d1a6c0af995c9b64a26d5489b244f1d3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a93fc8ed458b88e7a864d8c08daeadce6a55b381fa885b639e227222e7a7ea7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fb7b828122e4a4646c7345e4e21a960c81a13ac0170e116795878d9604d8f0b"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
