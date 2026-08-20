class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.23.tgz"
  sha256 "ac083f3d720ace8f058030a1bad3cb4495dda008e9ced6d493df6e18ed0d871f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2272b422abc97ad99e56bec6941b696ca9f049a720ca9c7752146ea0a76477fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2272b422abc97ad99e56bec6941b696ca9f049a720ca9c7752146ea0a76477fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2272b422abc97ad99e56bec6941b696ca9f049a720ca9c7752146ea0a76477fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a736583ba74a2a95e13b654bb312e6d97deb418fefc680cb95581e63745ca43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc806937ff5a527cf8e2ce103aab198381aa71ae085416076647380b36de1b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc806937ff5a527cf8e2ce103aab198381aa71ae085416076647380b36de1b53"
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
