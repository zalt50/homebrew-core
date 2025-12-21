class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "10195c18a393c3a56dc9831c4403505bcbd4c91f5c0c26ba5d5aaf5f2e5905c6"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed37261d1b84966d5217757c1832e8e5134f7a0927279a3f9751c88a07ff147a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70693b0e3390e5dd9763b8d3a3917d8849992fd5b25167136c21afd8aec69951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d094d5f20db760f84142444c70d7e0a10ad729f3df5b239f30b4f77c1c57d960"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14892eedf818a33c33db55701ecb2d55b05fce9961b413de5bfdf605e0f26d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46fdd792827f1ad8eae03a8da9d2977dad42dea3e40b10fd0afb651edce16555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bddced452023d648622a22eb5e82f01378c5a2a08511e31c5b317164772d67d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/mdfried #{testpath}/test.md 2>&1")
    assert_match "cursor position could not be read", output
  end
end
