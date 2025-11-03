class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.39.13.crate"
  sha256 "93d1894ccd74cdef313ae2c52b1e0be102b0a5c1335645b59ee69225469e787a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18f4184d5e3a8a6a70450b5e892876dabc446ecfa4272376a7667444055dcd2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef7c42d093c4bcdaaedf60983e393278e8fb0c8f46282b524a8e5f23a3ab180c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c7b5824bb923bf46119b234cebb5452e11bf5c8a077d3e267ca5d51ce8122c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f514a8a9075b461e71d77138068f960b9bf6268a1a3b32eae83e49c12eb3eb4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7486edda3206fe2a75617606418ac8e886f3f7f2398aff607fbde28eb83cd39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a994a6a47dd6c3c7d336843ae85f8cfba767725085b13fa75324292a95f17257"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
