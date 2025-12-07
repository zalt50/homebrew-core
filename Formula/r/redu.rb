class Redu < Formula
  desc "Ncdu for your restic repository"
  homepage "https://github.com/drdo/redu"
  url "https://github.com/drdo/redu/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "e7459b4dd3e6d3627c6902aa1024e3d33c4bd3474c9d55c3fed917fa28c64526"
  license "MIT"
  head "https://github.com/drdo/redu.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redu --version")
    assert_match "Error: restic error", shell_output("#{bin}/redu --repo mock_repo mock_pw 2>&1", 1)
  end
end
