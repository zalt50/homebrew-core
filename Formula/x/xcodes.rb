class Xcodes < Formula
  desc "Command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.0.3.tar.gz"
  sha256 "ecc37bc69a6eb343a3c58f5edab42169bb2c4d38266b6585dbf5738d3eb59eda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b24c153e54448a55cfed1f1e2d547cc714abf15faefc187d72443306c4cfc054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1adf300abc73b959d49ac48a92424fed029a4dc63d044dac05a589e97915b2b"
  end

  depends_on macos: :sequoia # older SDK fail to build on non-'Sendable' type 'Logger'

  uses_from_macos "swift"

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcodes"
    generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
