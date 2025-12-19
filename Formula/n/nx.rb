class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.3.3.tgz"
  sha256 "1a41938d356f18bc10909fcfe5ea39b4c978c2ee9198b4673e1d76b00c39132a"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "803656ce0082b6aefc7cb9f8c5b4905a54bb6c8598be91cfdf914e88c04380b7"
    sha256 cellar: :any,                 arm64_sequoia: "621593dc42f4ff3daa5b8d556b1e8612c89c51ed0c1fd552c4742ba0c0e6cfb5"
    sha256 cellar: :any,                 arm64_sonoma:  "621593dc42f4ff3daa5b8d556b1e8612c89c51ed0c1fd552c4742ba0c0e6cfb5"
    sha256 cellar: :any,                 sonoma:        "b959555be39b007e8b3d638e6b08968026bc0ac37ddd9cc2ecf70a35bd2e08eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "123345508ff08cc936532344a330787fcd2cc098dc9024159b2b60a08c571d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2c12fdea54ef0b4dd55ef3688bf5820035e329f4f40b9bc06c4e441d090dfc"
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
