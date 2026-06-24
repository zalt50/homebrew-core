class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.15.1.tgz"
  sha256 "fd6f658204b78a490b3ce26f1f1a0ed55247dc557c18a3e4cc77db4cf0cab4a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e652051a6f6654a745c6586ad1a35453f2ad4f1a08a9e51a32c9731433fb71a"
    sha256 cellar: :any,                 arm64_sequoia: "a6f48db2d096d0587c8e2c52122492ef4e5d3a1aa7db5578ef0989b3293437ee"
    sha256 cellar: :any,                 arm64_sonoma:  "a6f48db2d096d0587c8e2c52122492ef4e5d3a1aa7db5578ef0989b3293437ee"
    sha256 cellar: :any,                 sonoma:        "3f0a09a5a6847104e6a56bb81365186ff9fcea90b8aa589647a621485b8389b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b6213f80e83464af7e498a9ea075e4b4bf5c259b8954371411cd12ec4b2c625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a8e1b9b349809db9f398859341ed10cb488c01e8052f992af0b42018771cdcb"
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
