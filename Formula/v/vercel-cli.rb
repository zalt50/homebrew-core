class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.8.tgz"
  sha256 "d133e9a1ed560e49116738f5a2caacc7c02f981e9ef8799955bf738651dc778c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e51bae17cefa580a1b23a808e32b114888d585d8b8f47e92a9e72a211a3e859"
    sha256 cellar: :any,                 arm64_sequoia: "c69f9832b57131e8215fcb0d72c46bfff6cac1cc6aeb4e525b20d47ea191d181"
    sha256 cellar: :any,                 arm64_sonoma:  "c69f9832b57131e8215fcb0d72c46bfff6cac1cc6aeb4e525b20d47ea191d181"
    sha256 cellar: :any,                 sonoma:        "3c397195f769f7af89bab8545a4d914f5f59aa425dd5d645f2577be3ca749b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c3fdd9f0803a86b1677c384f83581ef6487dcd6ec35e7f8d53ccca0053d13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e434bbeba1f7a0489f581cb9d24e45e06794d0223f276099b90db8360868814"
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
