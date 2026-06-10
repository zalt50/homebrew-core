class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.10.3.tgz"
  sha256 "80e01ab2149746ed5022b34116a35e1b9cda3dd834634513c840fa12ed461c83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1bd90a6bfcd679274868cdcdc06da1e4057c4b5481d7d855d2919af97c49d06"
    sha256 cellar: :any,                 arm64_sequoia: "d935253723b9dd1817005a016c0872982fe90f3b9553c1ed134a31c25c8e7fd9"
    sha256 cellar: :any,                 arm64_sonoma:  "d935253723b9dd1817005a016c0872982fe90f3b9553c1ed134a31c25c8e7fd9"
    sha256 cellar: :any,                 sonoma:        "7f91f8c1686c96830b5826037e51f5b5305c62197763de044f863b219a0383f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f6594ef883493420a62cb069f44a4ba207c45a07811601438cc7e4acbc5650e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a38d2680cd6c3fdab6379e8877231823c14daf3ef683b1a66ef73c9be53ff005"
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
