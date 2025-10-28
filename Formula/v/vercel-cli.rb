class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.6.5.tgz"
  sha256 "5356eabe5f5057ae1a3762e22ff9b3a037131d0228ad27307fe3b9614dd07331"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "baceb21c072c7d63aaac6c313ed10621b61aea7bf1826dad4e4213b7c60a772d"
    sha256 cellar: :any,                 arm64_sequoia: "ec9064276a7e2df0878af16e8435ffacc4d2ddd4a16aaa105fca7ec045bff014"
    sha256 cellar: :any,                 arm64_sonoma:  "ec9064276a7e2df0878af16e8435ffacc4d2ddd4a16aaa105fca7ec045bff014"
    sha256 cellar: :any,                 sonoma:        "ec105045ffc82e71c000ba1fe1d09b30036ec5da8cf30531bcd3a4d2cde785a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a78f81003bb27f6072f79c899d9453f97902f1db730956e1005c9f026b9af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28bdd35c9e2c2abba89a17663ff0701a551ea429fd0ef32c7d720930d0548b6"
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
