class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.57.6.tar.gz"
  sha256 "5d5644ca6722607aac5f2b527200673b4f383c6b2c98ec778cad8a4aa8ce23b8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48885d6203fa77a088140427c3cc5be863ad1d1cb7a69f34d7bcde45fa87a9b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e4ebe1f7adc5c2e9e52b942b14fd7b31553400d0591790ff81642a87e5cd6ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dffede6545673c4ae1d29dab421906db7244e4cd9e9e0c50a8fb5211ae5efdbd"
    sha256 cellar: :any,                 arm64_linux:       "83a9c1f894e4a2f330be57c6dbb04e4e014626b70f6452ac019f27b067520120"
    sha256 cellar: :any,                 x86_64_linux:      "2c8928e2e3f99a03dd1ac29894956eb1d1a4b546165c57dc96b4dcd22c6307e6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
