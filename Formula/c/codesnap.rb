class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "e1636f08781fdb6e380428bd54f458f59b7764702271a7f2f407ad4432753c33"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee2783935293b574c17651936f5b29889e2b949197105e60d8fd375d7136056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a41f0f2d35184ecc9b985a22c2decfd2af34c5e3788eac0cc87a132337d16d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50c60255897eeae5c435edf62582f9bf3da2c15d9b4d9c0ddb4c2cdb6d9f6ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e7d8a1d906cedd120a72f78abeda8c2642cd206222e717c4945587a43adb98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa07bb208cb58cfc0c043645af6b37bdb1dd55e7da0ee3d60a3d452bf325159c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4054af86c3decea8d02eb249d2bdfd141e2db31408c01fd7a0e09bcb41acd3e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
