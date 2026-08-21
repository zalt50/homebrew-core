class Jarl < Formula
  desc "Just another R linter"
  homepage "https://jarl.etiennebacher.com"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.5.0.tar.gz"
  sha256 "7b1fd11adc3924fa71f3a4202a2a4a87f1c8d62944160adedba65eb8f01d1cda"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    (testpath/"test.R").write <<~R
      # Simple R code for testing
      any(is.na(x))
    R

    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    system bin/"jarl", "check", testpath/"test.R", "--fix", "--allow-no-vcs"

    formatted_content = (testpath/"test.R").read
    assert_match "anyNA(x)", formatted_content
  end
end
