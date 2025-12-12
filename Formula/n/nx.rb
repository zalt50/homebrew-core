class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.2.3.tgz"
  sha256 "8aedff794de149331371d63940d010a5241c209fffd3c413074f390177e68c49"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5771a72a206f4645d2ee6d4249f1cb5868ebc4026f63bc0bb94f6114b72be8f5"
    sha256 cellar: :any,                 arm64_sequoia: "dd6a311aca05456e66a3022c40048855fa5f24e92b69d08a72bca9b4f40900d9"
    sha256 cellar: :any,                 arm64_sonoma:  "dd6a311aca05456e66a3022c40048855fa5f24e92b69d08a72bca9b4f40900d9"
    sha256 cellar: :any,                 sonoma:        "fdce59a86b4c75eaf1f9eab229e3ca0613e14df857cab4af5d1af138fc2f649d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aabe2bb7b2c559fd3c5a734a43600613e2c0674359761b27209a8fdc6da80cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b91ca60e4aa5733c7a4adfb2e8212a111806b3be629691c01b945af0e27cc5"
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
