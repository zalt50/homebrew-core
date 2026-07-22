class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.6.tgz"
  sha256 "feb78d3d12aef53b03e38a2d074c2fb63aa161feb5a63dc837f9c81e0f5af10d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e626f27c76a1f4821049104a34ca30ef20ae175c3e596b799899374a1914c935"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e626f27c76a1f4821049104a34ca30ef20ae175c3e596b799899374a1914c935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e626f27c76a1f4821049104a34ca30ef20ae175c3e596b799899374a1914c935"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbcceda1df0877f53d1a488703ed8e422ac07a70e6888153ac8da766fdf92f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "984d7f389aa8d31d4284d677f5a2710617cc0f831e3123306e3288ae11c4cee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984d7f389aa8d31d4284d677f5a2710617cc0f831e3123306e3288ae11c4cee4"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
