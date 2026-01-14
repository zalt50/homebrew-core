class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.0.tgz"
  sha256 "6a2dc24c0019965cde3d2cc1859b6264af938d7106d9001c0417fa998d9dbfa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "213f3da77f1bfbb1fc90543551ae54e1e5c200543d1b422251dbabd61d611eb7"
    sha256 cellar: :any,                 arm64_sequoia: "afe312607fb2e1465cc44a954e33f5df0ef37c9f399198b2b836ccc2e49b22b8"
    sha256 cellar: :any,                 arm64_sonoma:  "afe312607fb2e1465cc44a954e33f5df0ef37c9f399198b2b836ccc2e49b22b8"
    sha256 cellar: :any,                 sonoma:        "7c3b40653b02f6d208218838ee64028d5c5bcd899cbbebed23377f76cdb8d2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d89b3a4970b24a751230406b3e2cb3bb936621ad4306ac86d4495c75be44cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adb617c5e39df72a471aa33ab975009c896c7d2a53df1c13f038b58d3b39f8bd"
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
