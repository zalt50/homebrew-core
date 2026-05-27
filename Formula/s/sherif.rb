class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://github.com/QuiiBz/sherif/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "4069bb60326caf7d50d06d15e85e838707206f061319461867101046e4fe01b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe5b5fc9e5c3fcf97c87dd48df2b24ff667ca8a5ae733bb4ba477e4509c7d085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5b5fc9e5c3fcf97c87dd48df2b24ff667ca8a5ae733bb4ba477e4509c7d085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5b5fc9e5c3fcf97c87dd48df2b24ff667ca8a5ae733bb4ba477e4509c7d085"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bfb8c4be21f2607f0e6c48014bf08dbd94a799b8fd4d2676faa2621ff7d8085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91dc05db3f972d6442b8b9737d0e004e4408233ab3f27135fb46ca7bd78bca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8462088add169c0f5395acd404a7a56bdc12393938c7a479d47ce635ef60a914"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
