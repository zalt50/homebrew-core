class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.7.1.tgz"
  sha256 "804c02a603d44fa9339af89ae75747dcc2d4d91914890f121bdc782dde530754"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2816d4e1ed6a7b7f30105bf28853bce507d69ff13d00517b9cddbd9d097e6e8f"
    sha256 cellar: :any,                 arm64_sequoia: "b5891407a35cd401d1cb6c749619b0f9382ccf97fa7a1931a6428e5bd91a13fb"
    sha256 cellar: :any,                 arm64_sonoma:  "b5891407a35cd401d1cb6c749619b0f9382ccf97fa7a1931a6428e5bd91a13fb"
    sha256 cellar: :any,                 sonoma:        "86398fa593b5e3c3ec6cad7ef24bcdf8ed5b5048326ae452b1dcc13266391e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9509310996ccc85287981a1a52c332011b45237ec583a7747f198f3997b9b1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6603197d7911f54d7d550b24756f8016adb3e46b61ae8ac49ca1fed0e5fb5198"
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
