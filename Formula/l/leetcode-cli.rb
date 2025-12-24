class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3ee61769f40fd374461dfe9a7cccd113b38564e828bcccabf1875d9482b9ced9"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a40789807efccb65b3365e5434536f6480cff7d406770ecc4aa7e50ca3aae203"
    sha256 cellar: :any,                 arm64_sequoia: "cb8bf9404dd0a52c04f6da02b582c8bc0433ec93fc6281504dd3b82b3df3852a"
    sha256 cellar: :any,                 arm64_sonoma:  "ec118770fb3c1df6dc257fe0456c6dab89b5bda540a37c2f79945663af24e374"
    sha256 cellar: :any,                 sonoma:        "28acc738d77e010881a9a84ac7abcbee8bbd215a32e70660d2c35327602cb2ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d8f935f81a18d9bd910cc8aac738c7c24ccdedcec3975c7489fb730e901bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65f7a14623a2066d509b063e3845841ba2078f0b452c7354239f1dcc2ec83f75"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1", 101)
  end
end
