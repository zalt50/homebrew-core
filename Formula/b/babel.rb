class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.28.6.tgz"
  sha256 "f615e694e3af72ae0f522d765b905454921ec4e81eb63c24b17b963a41463390"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@babel/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"script.js").write <<~JS
      [1,2,3].map(n => n + 1);
    JS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_path_exists testpath/"script-compiled.js", "script-compiled.js was not generated"
  end
end
