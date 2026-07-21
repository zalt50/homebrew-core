class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.19.tgz"
  sha256 "e5314f2504c37e7e8079ab70d4d081c14eff4815e79fb20a8364cf815afe17e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9e1d29da67f170d4f849901dd33b8c43c8492fe4f54c236bfee3bb1a4af305f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e1d29da67f170d4f849901dd33b8c43c8492fe4f54c236bfee3bb1a4af305f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e1d29da67f170d4f849901dd33b8c43c8492fe4f54c236bfee3bb1a4af305f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd0e2bd354e217b817f66399758869d2416ab7b35674d4cfe9610727f965059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dd0e2bd354e217b817f66399758869d2416ab7b35674d4cfe9610727f965059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd0e2bd354e217b817f66399758869d2416ab7b35674d4cfe9610727f965059"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
