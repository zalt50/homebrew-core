class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.12.2.tgz"
  sha256 "a2579daa10508398aa4458acb3aba0c176242821813fbfc7542a9d00a2e2f070"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "711fbfc4c0febd6a6ae920b48a7b76921aa2e019d98f10819fd31571e3c6a945"
    sha256 cellar: :any,                 arm64_sequoia: "425936a0c4806276edf19a626b1e0d1a9561b5fff85735418d97ee239df34f18"
    sha256 cellar: :any,                 arm64_sonoma:  "425936a0c4806276edf19a626b1e0d1a9561b5fff85735418d97ee239df34f18"
    sha256 cellar: :any,                 sonoma:        "61c7d69f538cd704df8a44ab38feab7f8778fb6266a82e9c96fe09ccfde6d5fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a16707a959fe609e5b52397b29cf4879de3265a617d24eb25fd485a3dbf0982b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cdb8b586cf482cb409e489c62aa4f298ca4ad6a5bfc220e1b26cb080c4c227b"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

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
