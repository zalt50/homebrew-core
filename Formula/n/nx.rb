class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.6.6.tgz"
  sha256 "b8aa62554850b755e3299bd71bed112b9953626d2977228c848f41b9537060b9"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "479c0009c159d2bd53b413a18496bf1ccd111819117e2cf64e300fe9e2ca7a20"
    sha256 cellar: :any,                 arm64_sequoia: "e6248f4b43fefc3eef841fce6eba5ec17c438691e06fcaf0c1169a476ea62b62"
    sha256 cellar: :any,                 arm64_sonoma:  "e6248f4b43fefc3eef841fce6eba5ec17c438691e06fcaf0c1169a476ea62b62"
    sha256 cellar: :any,                 sonoma:        "f876823ddc02aee0a4a9eb1bcb1fce5a8134e1196db52dd82890a452e15459c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c26fd2ec3ffaa4c9cf87905144635fe7ace96bdbd6c21bd885bd03c649b19184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1419e97eec3509a765dd79fdf446474a33ae6a403f715c5bb3a25dc5b1911f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
