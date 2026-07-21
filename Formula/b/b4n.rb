class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "8764b07ae11c0474337112b5da1387c01cb137b71d4def93b0eeee72db9af495"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end
