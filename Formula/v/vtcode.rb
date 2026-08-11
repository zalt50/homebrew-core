class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.143.0.crate"
  sha256 "b8ade2343759e455d7cde3dae05fbe4ffa66af140c46eb3ec8204435ca7ce1a6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28830b661a14f8039f2e64e2835f4d5195a48258063818640a7794180fd6698a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8193ffd1f14e7f54393a164f4043643583489a579cc36e1cbbc4a0ba3aaaab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba30a4cf8c8b1b1d397ea3cff240c75cfa3bebbbde31be84300398ba489d487f"
    sha256 cellar: :any_skip_relocation, sonoma:        "87593a1940fe2cc58425c412eb35dff7c4133a69c68964230efdb811a2303325"
    sha256 cellar: :any,                 arm64_linux:   "c745dac679f356d074e4134c1c79f7522ff8f5699c2d85c75a977236d36c6e63"
    sha256 cellar: :any,                 x86_64_linux:  "0cde2e887d49c735babf66b173d16cb0e791cbffab3017c4b2822d7dd3d6bb37"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
