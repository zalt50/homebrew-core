class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.3.tgz"
  sha256 "e6a1b07aa0bf7d766d757a9d330375e9a981cef562996415826b6698d201617c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f672add67d3eee5e295de8a62f068b0ae97ab362444c8c1ce327001f85dd9a4"
    sha256 cellar: :any,                 arm64_sequoia: "6ebea756ef071101c1e003af0575f342e7d0e4909980d62375e73248a876899f"
    sha256 cellar: :any,                 arm64_sonoma:  "6ebea756ef071101c1e003af0575f342e7d0e4909980d62375e73248a876899f"
    sha256 cellar: :any,                 sonoma:        "eedff3ac0ba51fe57434f6ea1dfe7742e64a712327d6425205789dc797c5d6b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be057c97f4da09be2737278fa47584fdd80d608276536b011160d734d2711ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd8bbf21199c63adeed5343675802772c7b4be17add6a2be3fdeb41e47ed1046"
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
