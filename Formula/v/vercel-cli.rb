class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.1.0.tgz"
  sha256 "26ec84ee990604e3d145c2abc3da8ce9618b140e926bf25e09963af916c1f6fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60e9a6649144ea2fe732b9e882b56355a9edcd807bd7039eaa98e219f572a72f"
    sha256 cellar: :any,                 arm64_sequoia: "60e9a6649144ea2fe732b9e882b56355a9edcd807bd7039eaa98e219f572a72f"
    sha256 cellar: :any,                 arm64_sonoma:  "60e9a6649144ea2fe732b9e882b56355a9edcd807bd7039eaa98e219f572a72f"
    sha256 cellar: :any,                 sonoma:        "bd25379c027230a4cd708a8f786db98ad9f67b13caf3637625fa030f9278e68f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d96afe244785b51a4e897559b9defd505ea24e9dd6670ac9a99717fe77af78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93baaad54b6082e39cc92c2f141a15e53197504453aebda57cb0d6754e51dd2e"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

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
