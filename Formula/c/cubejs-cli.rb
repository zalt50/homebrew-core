class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.58.tgz"
  sha256 "295eb1db0bd0067bfeda44f491d0ab3d4d9a0dc315aa6e364a25f16487188804"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e777fd1ea8308374d49915f02de1c5fac3d5a453168ed32241704c800ce2510"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3580aa2c3022adb002fb1505eba16aa5be59668b2193ccfa1eb9ed77476bbcd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3580aa2c3022adb002fb1505eba16aa5be59668b2193ccfa1eb9ed77476bbcd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "35de24df315fa290ffb03f40f5159d83a2d8f812df62594c0e187efc1f617f18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3dd4bf97336347be4c7d8c8d6ea1c87d0874faf41f33a5ce4d03fa2679cd5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3dd4bf97336347be4c7d8c8d6ea1c87d0874faf41f33a5ce4d03fa2679cd5ae"
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
