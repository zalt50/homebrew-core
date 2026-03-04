class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.39.tar.gz"
  sha256 "a05482f5d4cbf6e3cf534953a9b049d2c554ab799e93453fe820dddcdcec2b7d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d53bc201db4e070c5422150b5d6664842aded827c8779440f2296e7864bc7862"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36cfd6286211d529c4469b6659695e68dab31a248863aa36d043e35dcae81f64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c225dce68aa2d5eaf13d500d6e38dd93679d4690678e8bddb428fc1fd115649d"
    sha256 cellar: :any_skip_relocation, sonoma:        "49f906c15c3c4c5c3140e028647e8479ad0f2d8c4515e237415a44e37ad8e642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8621a79a3095ffbfb665205d124d8003b86f614ab14064b98f86ae2df2e27e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49840dc39325841c070ceb724be6f54de4125427b6f919594a77be3f048673d6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
