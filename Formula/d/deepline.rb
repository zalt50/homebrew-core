class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.300.tgz"
  sha256 "9317cd363c20187cff5a55885146c1fccb3ab47b98af980aede87cf86dd805f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3870ac0d875dc91388849ed96be419f7bbe00dfc1cbf1051e86f59c8adf27541"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3870ac0d875dc91388849ed96be419f7bbe00dfc1cbf1051e86f59c8adf27541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3870ac0d875dc91388849ed96be419f7bbe00dfc1cbf1051e86f59c8adf27541"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd537be934e559dff1b97d5cad8f61cf071d93ec62a0293cf014d783600f4082"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d31acfb2fd54b6d5d0da3a8f49645a78e9988e81de4267e44e89b35318d0122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5291a1eb62680f63c1a9c1c01674978e88c149dabc92fea080f0a73e3e830e09"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
