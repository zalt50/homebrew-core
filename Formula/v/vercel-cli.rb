class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.16.0.tgz"
  sha256 "3be0d514fe22f04106ede62f9f314a0ef9eeb482d0d71511610cc9e16a5098f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb11ed58027f151aa0e93d94cd2050ed060e400cc8a2827baf20ec11c5c4b75d"
    sha256 cellar: :any,                 arm64_sequoia: "74e60c8452aff212a8de4b99167a54cea606a9c7f4016c4f2139ea228d3c9776"
    sha256 cellar: :any,                 arm64_sonoma:  "74e60c8452aff212a8de4b99167a54cea606a9c7f4016c4f2139ea228d3c9776"
    sha256 cellar: :any,                 sonoma:        "a2b94b34a13a96ac4cb6b564b907fa161317a16437e459311d39c318e7280ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d1040ab5ac2fa81874ec59697fb0aeb0136ba08643b1568a6d6d56e1aa69ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28c749ec7079860798bb152679bd555975bb6cfdf08a37dc51b9499469636cc"
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
