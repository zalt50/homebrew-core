class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.15.crate"
  sha256 "74a4ea975ed03cc8caee91e2a5b9cd0b6293d59b57aa600975347954e3a45a04"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3498e1224f1fd3a465fa89f94a8305d08e46e068b3d7e02d32bd79d659d3e43e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dca456153e68d57f3678f1c824a9760a45233bfadb98c3fb35227570da3aec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec7af39cbe74b147f1aca4532e013d02bf713dab423f4e68ad6a3ddb90b082f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1417a11856a8b7bdefa3dcf763c92098edcd3f512151b0b3466e7b6c9df5f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be33fb3d2dd8b1af7181ff1232e9aed90c0d0a2d07e07c05920dec4572fb0a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bac9b95c5c7e64c00f360effe05dc0e4c8fb5e45c3711bc05e38ee7b240f3d06"
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
