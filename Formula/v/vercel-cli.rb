class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.11.0.tgz"
  sha256 "94f2a9afbb9f16c16d2232d68ae011a12b57b48188072984c9172ce05a7ac415"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e848112af4a1ce8aca3a8274f26b5263027fd48cec3789f965e7bd2d996d261"
    sha256 cellar: :any,                 arm64_sequoia: "653a93ac9e2695c8a2eed739ebad81dc824a5eca7ba7f78b67fb080f37550dca"
    sha256 cellar: :any,                 arm64_sonoma:  "653a93ac9e2695c8a2eed739ebad81dc824a5eca7ba7f78b67fb080f37550dca"
    sha256 cellar: :any,                 sonoma:        "75b2e6c9b7ead8ffe9b62fa1774c932dda6a91dbad6d34e44d2daaf3c38a29cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b57b4f660190d104c1c207b45a985bbf16caf4d9bb5b22b14e02a3ed46fce4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0390c32064c9e758d39a40caf4a3310d5ebaf67e274b8c747c293a078ec526"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
