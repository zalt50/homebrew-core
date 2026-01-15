class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.1.tgz"
  sha256 "e5fbe49bdcc40109bc109032510075610d9e826636c05d1bfd767320f766ebb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d85a1e0ef5c3c1e960cfa1ddc2dffb3f20c4fd4e8387418fa57ef959cf96e2e"
    sha256 cellar: :any,                 arm64_sequoia: "116a40e0486a04e8cde22266b19ce98504503e113eb9bd59726329d4457c5cf9"
    sha256 cellar: :any,                 arm64_sonoma:  "116a40e0486a04e8cde22266b19ce98504503e113eb9bd59726329d4457c5cf9"
    sha256 cellar: :any,                 sonoma:        "55a6ad59ae892adcd48c42886a20575bd008b4450575472740a61014f4e16f2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "414061a3fa2c1e22d3acea282aa3e1b5bfdbef7419b0a00ef8f9bf6b96d2623a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1144ddcaac1aa300e0ff43354e2f9366785152a2a28519ff7616f02c9a6bf51"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
