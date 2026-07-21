class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.4.0.tgz"
  sha256 "ea0bf3414807a2b83ecc39a96c0cc8cbde1f0e0ec9c4902f31878bf92749f7b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03f359736f86ec2269ec12be4d90bff29de4d3b2b2461c3e0405a114567d1478"
    sha256 cellar: :any,                 arm64_sequoia: "03f359736f86ec2269ec12be4d90bff29de4d3b2b2461c3e0405a114567d1478"
    sha256 cellar: :any,                 arm64_sonoma:  "03f359736f86ec2269ec12be4d90bff29de4d3b2b2461c3e0405a114567d1478"
    sha256 cellar: :any,                 sonoma:        "036d09d79f30c62a7e9a88a6b56f5ccf54cbc10911af4c462bc37866b3fcb0a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97bb75445de88d9b21ed595e7d76e0bd2c5a52abd0821ebe6e0acdf966ea0b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740646d4b319111fe37188d0f1a9214a7e1db0e08f97b7c7379c2cf36beacbdc"
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
