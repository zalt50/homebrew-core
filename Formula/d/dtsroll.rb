class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.0.tgz"
  sha256 "5b1d312de583d509393f288e6c63e7c705e7d9e6b4d5766568872fca07f0da77"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "392136e21e66d8b80b9436679bbe10fd79b579b4ce4ab1ed5e41628439c7d1c5"
    sha256 cellar: :any,                 arm64_sequoia: "8aa13a6befb022b46190b8b4a75073bfc02ac8c743c13547b4a5b33fc04155af"
    sha256 cellar: :any,                 arm64_sonoma:  "8aa13a6befb022b46190b8b4a75073bfc02ac8c743c13547b4a5b33fc04155af"
    sha256 cellar: :any,                 sonoma:        "6b05ca669d803a1ac58ea7753db9a650b99e01bef5fdd59545a6d88f32fc2f31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dac0d80cdb07ccae108b3ac51fe1d60dc2b02ffb81a32e0adf907035a2d43b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7026905c07f851bc3a43217c3949dec20a99443002351b9a30663983011cb3e5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/dtsroll/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtsroll --version")

    (testpath/"dts.d.ts").write "export type Foo = string;"

    assert_match "Entry points\n → dts.d.ts", shell_output("#{bin}/dtsroll dts.d.ts")
  end
end
