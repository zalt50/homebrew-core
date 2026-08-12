class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.9.2.tgz"
  sha256 "9a390ac1a732a85cc2e60e06aaca90fe574f40afa2f1b7c1629bbd6a5b2ec6dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dd870b38eb027737adf391b25799df3904dd5c668a0a477e5fe8dc306faa9ca"
    sha256 cellar: :any,                 arm64_sequoia: "6dd870b38eb027737adf391b25799df3904dd5c668a0a477e5fe8dc306faa9ca"
    sha256 cellar: :any,                 arm64_sonoma:  "6dd870b38eb027737adf391b25799df3904dd5c668a0a477e5fe8dc306faa9ca"
    sha256 cellar: :any,                 sonoma:        "b68b6c67917909489a3390f02715e1c15e04f168425149b9260f378d90d53d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b49a908c6795d301cd7e55d3095254536876d4a2a3748febd651a5bbd9b205ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8f55bbbfe2406ae852f2e2d41d586af97319a7a5506fe2c3947cd466c86196"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
