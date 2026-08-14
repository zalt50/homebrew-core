class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-21.2.2.tgz"
  sha256 "5deaaad9d9387ecb304712890d46a2cb1cfe709bed829b071ac1e596e67a06f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43977b2ebe4f2a973c58c8a301d3d1d7551b7e0a9eff1c039a3d2bf64f31a3c0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove comment to build :all bottle
    node_modules = libexec/"lib/node_modules/commitlint/node_modules"
    inreplace node_modules/"global-directory/index.js", "/opt/homebrew", "HOMEBREW_PREFIX"
  end

  test do
    (testpath/"commitlint.config.js").write <<~JS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    JS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_empty pipe_output(bin/"commitlint", "foo: message")
  end
end
