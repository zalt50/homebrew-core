class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.2.tgz"
  sha256 "81a3df93d97a36d5154f2ed0d0799827515803db7eda8e89dc479607c8ff90a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42c918cb3f137b5d1508a767c93a41698fe73542c0363c46c348ab3016caa837"
    sha256 cellar: :any,                 arm64_sequoia: "8cb154843cde8442a195f672bf0eb4e92408d438643c599cb077ce09ee16536b"
    sha256 cellar: :any,                 arm64_sonoma:  "8cb154843cde8442a195f672bf0eb4e92408d438643c599cb077ce09ee16536b"
    sha256 cellar: :any,                 sonoma:        "482d172b577d6a5518692369f629a328d6325bc18d946efb2a5bbb5259b55ab4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4231271e58dc3546c7745ba3c7791352ace312bf267333ff533cb6e786346a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f22a16d611302682a1977b1974608cdb199fedb363f977a0ee7ec125ab66cdd"
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
