class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "adc25dd70678cfa3c7964dd5247b718e9be598b069af933f6ded1c260dcb542e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e6d1bf9ec8031c4e088f8146878f32efb54f4c524448972202f4c2b3dcddef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e692b892b4ff810664ffe74ce366ab0c686199432e4a84151afaea38c04b89b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b43467c33f1f515d2d40d94ddde5570bc87069e38fc614c9128295fb216b35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b2ef972dbbb5916a90d70a5390b0b73952c3d87f73fcbe59ed9378908cf8c9"
    sha256 cellar: :any,                 arm64_linux:   "421e9200f12b51cbe16d6037822cbb2dd5f636c37e6d43847975e9696b0930b6"
    sha256 cellar: :any,                 x86_64_linux:  "8c7dd9e92cf0fef088323f06991848877bc3874771c9db0bb6b24b3bbcd3f6e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
