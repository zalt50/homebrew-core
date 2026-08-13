class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.9.5.tgz"
  sha256 "3c6bf8d5cf48346111f833b3f14367a6807c5732101c333a88efcf914b6323a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9169daaa68d3d7430e62496f57abb3c6a05aa37530c72b964d09f8245068e61b"
    sha256 cellar: :any,                 arm64_sequoia: "9169daaa68d3d7430e62496f57abb3c6a05aa37530c72b964d09f8245068e61b"
    sha256 cellar: :any,                 arm64_sonoma:  "9169daaa68d3d7430e62496f57abb3c6a05aa37530c72b964d09f8245068e61b"
    sha256 cellar: :any,                 sonoma:        "3a921c08f17b9222c890a8b7e2b48f804f6b46cda7a0da1178789c9b77a14199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97dd44dd7d07e567a7e9ce742e61fa1b57609d45b52d81ec998ba89813611b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f05871d4064b325899298b377a9c6747585d838ae9fc75bcab0035cb9f7eea14"
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
