class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.3.0.tgz"
  sha256 "74d2128b682dca00391088acb94e61e554bd94d06804651c43f9fd7a79694685"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4e92252d0905b54375a1fa3abacd74afd6075e39cd7001a0e1819d1e193bd16"
    sha256 cellar: :any,                 arm64_sequoia: "c4e92252d0905b54375a1fa3abacd74afd6075e39cd7001a0e1819d1e193bd16"
    sha256 cellar: :any,                 arm64_sonoma:  "c4e92252d0905b54375a1fa3abacd74afd6075e39cd7001a0e1819d1e193bd16"
    sha256 cellar: :any,                 sonoma:        "3633f4eebac527005e2358afff496837a3d85a45650e3de54e8763d498b11949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55d9be635e2df6f79692d63f499a0a30478094e399284514bd6f3c55e6e9cf68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220324d092d7cc11965818ed688201a56d1ad6ce3461dc9b6d15210581129390"
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
