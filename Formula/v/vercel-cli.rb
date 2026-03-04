class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.26.1.tgz"
  sha256 "a1ddbc3d47c7c384cd330a45f9fcbca3cf65bb4e21d8b5780845378a7aeec41d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc9fb8e57fa4a78e452d28be0991cd28dc50c7885030f9b8c449c991803bace8"
    sha256 cellar: :any,                 arm64_sequoia: "f2c324d423dbf366cc18e4aa7afb84c2ed0e63beaa9c87ed32116669ab7c8f96"
    sha256 cellar: :any,                 arm64_sonoma:  "f2c324d423dbf366cc18e4aa7afb84c2ed0e63beaa9c87ed32116669ab7c8f96"
    sha256 cellar: :any,                 sonoma:        "835c8eeaead779b7eb86b59738144d138654bd5ad8466d62aca3e1ce9e996e53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "338635e6b5230d19665c7ddf09956cd23acc5fae5f4405dd29f6b7439ce2f8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5299d853382ace0e008819c14b40814955ddc7d74fcc4004b6c16519f63627db"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
