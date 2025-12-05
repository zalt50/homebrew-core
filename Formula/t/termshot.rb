class Termshot < Formula
  desc "Creates screenshots based on terminal command output"
  homepage "https://github.com/homeport/termshot"
  url "https://github.com/homeport/termshot/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "61acbacbed1d761965a46f379dbaf81c459e4c310d5b85972737b891b0a5aa09"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/homeport/termshot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/termshot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termshot --version")

    system bin/"termshot", "-f", "brew.png", "--", "termshot"
    assert_path_exists testpath/"brew.png"
  end
end
