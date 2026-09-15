class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.63.3.tgz"
  sha256 "c9d339808a70da0d0728150e26d6b0ed736e08c6d95757a0c6bcc704278ad8f6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "743e3839495a5ef71587f8cfbfffb4239253741e0b02010fd4a6305ab48b080e"
    sha256 cellar: :any,                 arm64_tahoe:       "743e3839495a5ef71587f8cfbfffb4239253741e0b02010fd4a6305ab48b080e"
    sha256 cellar: :any,                 arm64_sequoia:     "743e3839495a5ef71587f8cfbfffb4239253741e0b02010fd4a6305ab48b080e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87dda0b8cad8b603176c1f749b993c98d9877465b57eaffc2ce15fde3ce8d501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "11862ae102957e8538e04c7e0933e9702809fd80fd0047e4f3cd79a5d6b0ad69"
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
