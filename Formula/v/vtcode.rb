class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.45.5.crate"
  sha256 "87c6c540535cdaf05865c1e8ee82a668f3868988b7452ab3a28857e745a7f6ad"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09231957c9606d7e45ae5fd409a73958f7e000ffe799996ab5dba2900121a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eff70302cc0a03911ccb3c139ed2a35c2167cea37d11567c8b4ee076020d257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8552702f8a37036e275457419cc217b67c90cca84bacba99097ee4b8fe074eb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "06fbbe03af4ab8d9c11ea0a9165fcd5eb30f69b6a89e714b9aa2c1c05521fa1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45690127eed9d975497392dc53484d9d2901c8a50c31b5c8991d1cc4296d2d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e88b6116189bc362364f6d938fae35669c42144d471f15583d690cb8109cdb1b"
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
