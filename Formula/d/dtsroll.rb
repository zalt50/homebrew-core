class Dtsroll < Formula
  desc "CLI tool for bundling TypeScript declaration files"
  homepage "https://github.com/privatenumber/dtsroll"
  url "https://registry.npmjs.org/dtsroll/-/dtsroll-1.5.0.tgz"
  sha256 "0df47a60f01130264f7f314f82d65dcf3782c215782ab7bb2da7134edaab3b3e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e77274c126ca0e35fa508288d65f17353c7190eb6d12218e9c9c89e7ce20197"
    sha256 cellar: :any,                 arm64_sequoia: "f4e9c696c1eff169a56afc231df64ddb3afd1a94a93d06df600cbca2f243ac01"
    sha256 cellar: :any,                 arm64_sonoma:  "f4e9c696c1eff169a56afc231df64ddb3afd1a94a93d06df600cbca2f243ac01"
    sha256 cellar: :any,                 arm64_ventura: "f4e9c696c1eff169a56afc231df64ddb3afd1a94a93d06df600cbca2f243ac01"
    sha256 cellar: :any,                 sonoma:        "16f1125c683e13616e62314f8e4bc91be5181ac227b3aeb99dcb1d4fc2035e62"
    sha256 cellar: :any,                 ventura:       "16f1125c683e13616e62314f8e4bc91be5181ac227b3aeb99dcb1d4fc2035e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d680c2184178dcc9f3288e732ee083f093a9dce24e8023b22c57038d67202af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e17a278f414e6c1c8efbd55f535d0ef459bb7c657b3ae2b4196611c21530e6"
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
