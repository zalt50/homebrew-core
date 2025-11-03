class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.8.1.tgz"
  sha256 "3b8aa2fa3a6ef425a8df3bbd90961f6baa4cfc6f95e83dd4f9d5ca439b83c5e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fca8184fc9a93c6364fb94d2c9dc059f58cb25eb0418924f7c15f691000e810"
    sha256 cellar: :any,                 arm64_sequoia: "ee9c72e4033297bb455904cabdf042d31028c207de3e89b20868859c971923fc"
    sha256 cellar: :any,                 arm64_sonoma:  "ee9c72e4033297bb455904cabdf042d31028c207de3e89b20868859c971923fc"
    sha256 cellar: :any,                 sonoma:        "e4554e8f5c2eca160808d2e5a9daf6b6448614e5a110d2147038d57a6ec00bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df9dfef1ffc53b5c4f2dc68741e857f0c7cbab11930b09113654147ea92e6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f367f8e4e8f04f0bb1ba52771da5d73c26c82819fccf7e388e4e0a9d8b07533e"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
