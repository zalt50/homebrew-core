class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.8.tgz"
  sha256 "d133e9a1ed560e49116738f5a2caacc7c02f981e9ef8799955bf738651dc778c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b42d1b22d87f66d5fb8a8a90c6e2cd08ef9422d45d015e41843d726e6e6afa48"
    sha256 cellar: :any,                 arm64_sequoia: "e389e0b7cbfab8c491a950b83a3b3bd52ee32a59ffae46bce01d6a01007a9dbe"
    sha256 cellar: :any,                 arm64_sonoma:  "e389e0b7cbfab8c491a950b83a3b3bd52ee32a59ffae46bce01d6a01007a9dbe"
    sha256 cellar: :any,                 sonoma:        "d81b7c135786a396135b293a5cce968b876913ba872ca5e68e3984b6f80a4b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85eece0becb2531de39f73c3d6d5b6c6cad9cf056523198edea2340152f059b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4edc8c276caed78567d8829c4b3d58f34d987fb9399f41e5f56d03462d70c1a1"
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
