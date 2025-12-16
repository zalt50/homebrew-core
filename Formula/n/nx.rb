class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.2.6.tgz"
  sha256 "91b3b0f760ca1b3b8f4976c03c30ce556433310d3666c71e384c89be279c7978"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6746e503da3778bfe62e7dcbfa0c308148619fd568a4f89b613c049d0748191c"
    sha256 cellar: :any,                 arm64_sequoia: "458d12f3d91a676224ef91336a22b69940579d01822f76f1aa4334effbe07c14"
    sha256 cellar: :any,                 arm64_sonoma:  "458d12f3d91a676224ef91336a22b69940579d01822f76f1aa4334effbe07c14"
    sha256 cellar: :any,                 sonoma:        "a9bf021746c151c513e3fc9f822192327b30f4456068f72428642d3f82a1a758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981e5b416ec332d399a8588aef5dcbcc230fc51be852619167675bdd0e8b30df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc561156959e81b03b2400f56b470ecd4c539dceea19c6039bcd2e8071838ca"
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
