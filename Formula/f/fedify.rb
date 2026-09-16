class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://registry.npmjs.org/@fedify/cli/-/cli-2.3.7.tgz"
  sha256 "f5ed834aa99ae26cf1a9bd4596faa7e1dad011b2ac15401bfb85e25c22491837"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7df73a30e3f4c94b6a6f413d1f9db774257d72e1c50910e4891196cbb695fe52"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    assert_match version.to_s, shell_output("NO_COLOR=1 #{bin}/fedify --version")

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
