class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.61.tgz"
  sha256 "51ec34e4e93d80463f42da41ff00fe18dbc65e4e2b1ef75382a0d41b2546f1af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "710139df8dccbbc7167399db9a3ad83e29421d20e6e662eaa52c7f66be0bcdf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e88924167a80cc233249a27babb586d6dc48574e990eac6335a47e233bcde93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e88924167a80cc233249a27babb586d6dc48574e990eac6335a47e233bcde93"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e1fb9c1b516863596d9dbcbe737349fead9378fdec76057a73dc52ba40cacf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20e8ac48ad30b29d958feb52e5bbe7d72c9947a454bf556f2c0b474f01bafbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20e8ac48ad30b29d958feb52e5bbe7d72c9947a454bf556f2c0b474f01bafbb0"
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
