class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.1.2.tgz"
  sha256 "97d0dd1791d040a68fe198309d3701e14e2cf9693d1e019ad99e51fee96852cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9200978fec4d64bfa47e5cc51c251b458060b61a4acd1f79c7e4e7da035b0b8d"
    sha256 cellar: :any,                 arm64_sequoia: "027539b51c01d2e4da2ed33cbf8bb825f15c2e3cf6fa0ebd43fff57a0bb18e81"
    sha256 cellar: :any,                 arm64_sonoma:  "027539b51c01d2e4da2ed33cbf8bb825f15c2e3cf6fa0ebd43fff57a0bb18e81"
    sha256 cellar: :any,                 sonoma:        "5a9522cbba37bdad790cb9f1ad1d320b8738a5d6ad2bc8af85cf6f0801573b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa6f6deccfca00224470e237d2949b27f0d6d22b47c0041896a5efb152b67f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da41aace358f7c3348b7dba3cdedc55cba884fef3770dc11a08d5bb780d160e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
