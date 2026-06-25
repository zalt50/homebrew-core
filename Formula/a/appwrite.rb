class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.2.2.tgz"
  sha256 "3d12da64bf9dc138da4c972f36184c91aa28301649c2e1377a68e02ca3f67bcf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97994edb197cb7d57de1516df32c8fdda4a2047b9b94af8f39ea5a0d1bae157e"
    sha256 cellar: :any,                 arm64_sequoia: "19dffdc65b18f54fd5891e964925e640b15329ccfe8c92bc9308d20e2a9eba2e"
    sha256 cellar: :any,                 arm64_sonoma:  "19dffdc65b18f54fd5891e964925e640b15329ccfe8c92bc9308d20e2a9eba2e"
    sha256 cellar: :any,                 sonoma:        "f93245a7138e0b07a472f43b7fa971d83f3dae2f8f2647d65ad6a18dfcfcd014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6d77ee09c4d492e22d6f4d07760629b7f08ea091b1561001b43fc3bbe090fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68722d2699f0eb2d8af159919114b0cd5b98daeae1182345f0e10db71f37e82a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
