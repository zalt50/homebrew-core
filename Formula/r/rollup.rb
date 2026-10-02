class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.63.6.tgz"
  sha256 "00ac7de7a8c0770967cc655a4555ba0c5d4aa3d5cc3bdba148326990def6b6c4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f932f73767eef4621902e222b14026cd5737b7fdfb3f6ee8454cf4034be45b86"
    sha256 cellar: :any,                 arm64_tahoe:       "f932f73767eef4621902e222b14026cd5737b7fdfb3f6ee8454cf4034be45b86"
    sha256 cellar: :any,                 arm64_sequoia:     "f932f73767eef4621902e222b14026cd5737b7fdfb3f6ee8454cf4034be45b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5f74712f84aa3034850502c1473b4904c9cfd74fb42118c1f748c72b8c211acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "76058c7707b915697d57dedf0ec934d39d2aa456949aeb6cb6eb9ead21be3be6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
