class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.7.1.tgz"
  sha256 "5f96b0803bf9afd76569fb8efe54e34a3bccc3cf5ccd80455b701236347d2acf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18bcc00248fa5b0295db52c6c86679b7bfdc30d38ca9ec8e5c74bc2a5d9e3f13"
    sha256 cellar: :any,                 arm64_sequoia: "2968110596c54982bdbb62607dd4c7d3905199904a9e7e865b125d1d0a1b1766"
    sha256 cellar: :any,                 arm64_sonoma:  "2968110596c54982bdbb62607dd4c7d3905199904a9e7e865b125d1d0a1b1766"
    sha256 cellar: :any,                 sonoma:        "ec3926f245118d8f755b0979a1de157f756ec47cf9df914f8ae49c61ec41a69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14b780f51a70068c1dd9265a0c8952478c5719d43f5d4a23f2f5e35bed250664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3ecaedc10539dbc95e7b9e91f905fa289567cef7535a7a0dbcc4e4bc0dd403"
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
