class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.4.tgz"
  sha256 "7b2db3d80f135c81c170d11b2a8349cde4352603340a2f6d5358da4161e055f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02581fd674fc1f5c10b10f6fc0d2a24a32dded0aa9c7e61cf88b8c8be54e1698"
    sha256 cellar: :any,                 arm64_sequoia: "10c3d711819a8f9e68c212c28344cce96a9208f3c32d340ecda6ddd84bdf87a4"
    sha256 cellar: :any,                 arm64_sonoma:  "10c3d711819a8f9e68c212c28344cce96a9208f3c32d340ecda6ddd84bdf87a4"
    sha256 cellar: :any,                 sonoma:        "9db473a97f585c73f02f034b16a6d207f436bef1ee214a8630c1f0b5c22a5313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d830181c45d49966701aa255d9fa3cad5d00667dfbec38d0f8b57717a24bc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c9c8bb19379413b991585d4c0656ede067068e1adba4d6204d72a43795038b"
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
