class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.2.tgz"
  sha256 "3b22a999fc2c308d4cc3db11ee42285d4862e58845a012317b6e1fcd25a2ca3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66ed09d4960e3896050e92a01ad90b27e03d024949b3e56d3bab99f168269356"
    sha256 cellar: :any,                 arm64_sequoia: "23463370292c506e6fc07311a3e5b155c7e4b4f295c511b48f79380f8f21439e"
    sha256 cellar: :any,                 arm64_sonoma:  "23463370292c506e6fc07311a3e5b155c7e4b4f295c511b48f79380f8f21439e"
    sha256 cellar: :any,                 sonoma:        "078839faa5e4c2b7c2e6b51c19fe5c4cb4247279460e894bfa24246ffc8b8583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a66554b0750ba21228fd9e6d6ac17367b702d6be32d06536ef5d954fcf4b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0820abd7d1b1d05171786197bb34123d46cdc96c7ef4ed76a78ec896a385c164"
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
