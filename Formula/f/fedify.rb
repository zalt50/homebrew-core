class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://registry.npmjs.org/@fedify/cli/-/cli-2.3.4.tgz"
  sha256 "97100e93607c886bce4390161128c32f825d424966ee12bc98263678b3e7d6ea"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5153411632ac1909737eb81c2007ac71845088cbcd194b7016960f54f8fe706a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4f284e3ffb20d12a196dabe61b41babd8a8ceaec1ec7ee830ed5c10499621f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3660f20b01fcc09649e2bd05ed02284938f4e99f0519a20a19cae18da88ca49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6edd4c6eaec44ebc44d92bdfa81a4030c625fdc8cae52a0c3bc35bb09d80e08b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dbd24f3b2ff54e3c2695e7452448ebd75ff5aab7dba84c82877aa0f3dff7f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9946cd382132c46a710c99cf430943c910780b818b78691f303bcbbd054cbc9a"
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
