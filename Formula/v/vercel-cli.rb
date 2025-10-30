class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.7.0.tgz"
  sha256 "99a037d161762ee45b0c553dc821106f4681af9c9412653dff04eb4d0b332fd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98fcdeac32bc4d79fc7eefd7a623bf6985a06306b13a3543db89a0f39448a025"
    sha256 cellar: :any,                 arm64_sequoia: "44853c3f4d43c72de49ff4dc1e40e6135d29f55e19a3041777e790dfd0db6a0c"
    sha256 cellar: :any,                 arm64_sonoma:  "44853c3f4d43c72de49ff4dc1e40e6135d29f55e19a3041777e790dfd0db6a0c"
    sha256 cellar: :any,                 sonoma:        "ca318d4a2d4221e82fa4e353bfd56bb145afb2e86f41eb1008706b832d296518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a750fee40b1f4cd70e2b01ab6c67c01d227a7602236dfeb542b79a59f3a936bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "168783a37206faa36f60c7443e72453868660e18ca4cc17bc3d6d9a0a728c52a"
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
