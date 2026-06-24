class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.62.tgz"
  sha256 "5a20ef95d709f1f48f6a64f4bdd22f934de81a15876c0817bc254abb12bddfa6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68a9c1a3c8a8d8fed4a284cd4d94839922eff3e0b019d98138e666ec45a95cba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97f5aa305998218f95064dd9de3963d3762be8b1df50268f754b8db4102c95f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f5aa305998218f95064dd9de3963d3762be8b1df50268f754b8db4102c95f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "981a3e7bc82cbb1085f1656a1956e5551d2abfabd6f2f0f758cd7b22afb9cd3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc00bd741c3f0df11985b5ec8f5c647b46b89b4daf4e7bbd65241986647ecc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dc00bd741c3f0df11985b5ec8f5c647b46b89b4daf4e7bbd65241986647ecc6"
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
