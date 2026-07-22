class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.7.tgz"
  sha256 "459c8f113ce1c0f2588790c4ef555b621c1624d8a26d74c43d40f63589879fe6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "111faa7fdd009e51c19a8c1aef8226e709de9c1f57a02f6c1b7835f0784e2492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "111faa7fdd009e51c19a8c1aef8226e709de9c1f57a02f6c1b7835f0784e2492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "111faa7fdd009e51c19a8c1aef8226e709de9c1f57a02f6c1b7835f0784e2492"
    sha256 cellar: :any_skip_relocation, sonoma:        "11dbf1139e8c12e5d904eb4003698059409715c8082d2a2859eab82017be690f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87238964e3369758de0c8e570a2d9f0e44d23ebce9a5f6e1b40ee5d2387ca9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87238964e3369758de0c8e570a2d9f0e44d23ebce9a5f6e1b40ee5d2387ca9b1"
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
