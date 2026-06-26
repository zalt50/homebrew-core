class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.17.1.tgz"
  sha256 "2367c720f091d88fabac51cd111e62b57d5b09dba96f0bd13f2d998e2eadd92c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a9311fc7a03e8e0b5f75628787f7470e27a1ce23a159af967a0246a3f87fb14"
    sha256 cellar: :any,                 arm64_sequoia: "2855a34c4f9bcb761efa88be62e4afacdd04737243a369ab5dd46f682ccd2e53"
    sha256 cellar: :any,                 arm64_sonoma:  "2855a34c4f9bcb761efa88be62e4afacdd04737243a369ab5dd46f682ccd2e53"
    sha256 cellar: :any,                 sonoma:        "6d5ed880312b965e8ee595e0987709c7689a8f197135c8db5f414af95c5af3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cbf95e8d0862f3e0e418890f82aac52df14674d2bce9d3468b4f325c2d0f8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c85b11ed0d449b497b45e0c012fe53a7eb4035b609fc8ce989ed6513e84c34"
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
