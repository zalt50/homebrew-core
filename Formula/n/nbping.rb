class Nbping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "344d49df5a117be5b52662113c84581f8b8c245b3f50cae40bbb944a4fce89c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "431941c8712b6981348065f4a865033d34c80dfef91ec7ce96abe5f487312a70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "440744007b50d7a9a93eb793a1cce71ec83063cf11bf0cbf7b0c0c7db22fbbb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8df3fd2a114c3f850bdf55daf0c5210443718251a96fd7ff1d5dfc89e8ac44"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa582923df94fedb96125a9103c6b06788fb82ba6e513fb64133e28238fde6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d09fffb3d8f23113b8b7fc3f8d4b621f04461e3a5d963e1880de665638f5f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a84486b4e069a4b8db18578295337209d4504ea001926606eb5e6e80c6c936"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nbping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nbping", "--count", "2", "brew.sh"
  end
end
