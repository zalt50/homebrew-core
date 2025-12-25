class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.53.0.crate"
  sha256 "46740cbec6e62fde2d8e509f0a011abf6a227597cd14aac67085f6d3bc215934"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6717d290bfd0a33ebbd6d7b9da5b969a397f65fe4e6886902c62f16e89c72c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497799567ec078afa47c7b7a4a6ac2225abcb89e9cd42e657e94834f8ddfc519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "334eb8072e1e67f0d09991980111b74d292b9c59fb01b00c275936456505468e"
    sha256 cellar: :any_skip_relocation, sonoma:        "551f7dca9fea0e2d83f167b7bd7317cacffbf67a16825199a58c0b795dfe4809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23c80a90f9515fd40a985c59e8f7efee6b4c483708521f8779eb57a64c85dc69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91c84b9dd65fe672673ee5a90627383c0d1ec5b3e2ed3f64dbb8356f1994017"
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
