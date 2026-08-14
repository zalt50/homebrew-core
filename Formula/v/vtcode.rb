class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.145.0.crate"
  sha256 "503982fcb9caa3b8646686d1598b9ce5724e5b4e2b025d4c8006cb36b37c00a6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d96735c9864a76bb941c1bc89d14fd82f03e42391c681f6b2de77f1446d6feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5c62337694c246787d9b4c272c2f92246832e5b099998f8819cef592f65aac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be996868e21128c053c30895ce9a08a64e20d01dd9b40e6d3839cd3bc6e64162"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f66abb26bf3260084dd4935522033a658dfaff3d33a844492553fb3df5d9243"
    sha256 cellar: :any,                 arm64_linux:   "3c6bacb60416330219ca1dc32cc58a1aa9327c4ea29668dfcfe8286749148e7f"
    sha256 cellar: :any,                 x86_64_linux:  "e2c50268eb0fc2e8fafe54571cd6fcbc944e6860157b2b944a46ae230ba5b43f"
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
