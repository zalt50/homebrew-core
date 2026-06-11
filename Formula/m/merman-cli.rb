class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://github.com/Latias94/merman/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e1d787154be74bca8262cc9c83ee3cb3f7e0c13dd4b8eb65c41cb2e42d3b5092"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/merman-cli")
  end

  test do
    mermaid = <<~MMD
      flowchart TD
        A[Start] --> B{Decision}
        B -->|Yes| C[Do thing]
        B -->|No| D[Do other thing]
    MMD
    testdata = testpath/"sample.mmd"
    testdata.write(mermaid)
    assert_match "svg", shell_output("#{bin}/merman-cli render --format svg #{testdata}")
  end
end
