class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.3.2.tgz"
  sha256 "d25fc8c4f2f2a41b05221f3a0b45f6409d5f2b3b62837dd320d4d522296b070c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b9cbd63093428102d1955b0ec2fbd07d32a183dc03b940b305bb7aad7f96f96"
    sha256 cellar: :any,                 arm64_sequoia: "4b9cbd63093428102d1955b0ec2fbd07d32a183dc03b940b305bb7aad7f96f96"
    sha256 cellar: :any,                 arm64_sonoma:  "4b9cbd63093428102d1955b0ec2fbd07d32a183dc03b940b305bb7aad7f96f96"
    sha256 cellar: :any,                 sonoma:        "befe99fe5d9327ba1c461645c8c33ab74194b28a1d7e67266de572efefd0c33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "556f24a3f426cef67a127bcb792cb411bd69fd20dd2d93aa035220025fa278e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8bdfd91a9af1256445264b97a18cf51cb9839539e8d9ae08cc10da98154088"
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
