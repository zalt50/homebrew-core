class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "1a158f346c3308bad51d8ab731122f6d2e716499fe004a695d195a93b7924f43"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a5db2f972a1acb355c17586f7acc7308250b066f2460751c48e8fbf945fe70c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cf7d172d55aa136fed990a344924383cc61c853b6a11143ad74c96e4a3403df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07baa20a0d1da068725d291f130088deaae11b3216cfa5edcbefeb1882ef9f29"
    sha256 cellar: :any_skip_relocation, sonoma:        "e14ad916c71da05a9dbdf6db3de98fb75de1b7e09e3a0dcc72575fb071b607ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f8122806c317de414ea777c3d1e5f27bbd233e5fa14cf2443804d56baad67d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc224d4b4e729f798ed4c70e9399af92a8cfbebb9b66b2ebd9124874f9557ea"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
