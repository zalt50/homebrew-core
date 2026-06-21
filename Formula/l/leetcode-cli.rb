class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b68d85ffdfcfd5f6a2e71184558e528a7d0c0c466c039494b9ef90b74e3e7700"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3691be61d91e166e8c7569e3ca068e2cf1001c0ed7c76bba9c292f0e09023ba5"
    sha256 cellar: :any, arm64_sequoia: "f22d8a0712e622c86c26f8463f4250c5a831b197c6f22d299a03046b12c1a518"
    sha256 cellar: :any, arm64_sonoma:  "e98c6ae79e6daf50412b7d81a1d8c5c01221dc86c8a5095a913b4f4badec8f50"
    sha256 cellar: :any, sonoma:        "53962fe4f7698c3b52cc144b44dcca6f73c92c3b2b282ab289e3d411c80ac5c9"
    sha256 cellar: :any, arm64_linux:   "d44b82cb982bc6474ff9d3b9751d3d7caa45d54bfbb1bac7e7ed88095d29e823"
    sha256 cellar: :any, x86_64_linux:  "94183bfd2a3818222bde852001ffe93a17f1c9f90edeb982c652345633d0c1f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1", 101)
  end
end
