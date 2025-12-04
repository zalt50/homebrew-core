class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.27.0.tgz"
  sha256 "09f6af948285fd3f72df7cf5191f10352f63143334df38c66118875527cc2aa5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58c237da31f7e611e79689ecc1379b11d9d6d8c357ec653e0812ead2d30752d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58c237da31f7e611e79689ecc1379b11d9d6d8c357ec653e0812ead2d30752d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58c237da31f7e611e79689ecc1379b11d9d6d8c357ec653e0812ead2d30752d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2712e34dfd8d803d115120bd0a5df98cf108073d3824006f40ccab5d551ad147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1eed095fd16ca364f4eb14675ff20110417b1ef751b003db6f3950da203fe6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e8f28271138d11829214a7eaa275c20d10572d7dd8fd66f6c4d68f4f974398"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
