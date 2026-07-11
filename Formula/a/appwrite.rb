class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.6.0.tgz"
  sha256 "e094276bd4036fa526b4dd406a00c8b4d08bdb3d462d782462cbab5c9b43ebd9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05536ad0e51415db89572f8849911962ad509d88dd3b82731add021b43843843"
    sha256 cellar: :any,                 arm64_sequoia: "6532cf1fea2e80afd7f94e65e3fe031f905cc2a35836049854f64102d6469ecd"
    sha256 cellar: :any,                 arm64_sonoma:  "6532cf1fea2e80afd7f94e65e3fe031f905cc2a35836049854f64102d6469ecd"
    sha256 cellar: :any,                 sonoma:        "ca57ec42bbd3ddf1e453d677f5d9c413fb6bafcb7cbc6441ff4b70376a9effec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a3792684211bed97cff960ae407d254d9db7bd186d1daa1936a80d4a02cad7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "767773de8e0b40544a5fb10278ce1e2dae5308ff0e97f071b8236b6e44539465"
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
