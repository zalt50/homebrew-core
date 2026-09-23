class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.24.0.tgz"
  sha256 "43f3e82128854df8c6f2909f82ca51da3620409d1200bedf64c113ec8574e001"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "410a9e68644ac91880f8ca1f9d7ead86ef614a42e950ba7153ecbd6254234335"
    sha256 cellar: :any,                 arm64_tahoe:       "410a9e68644ac91880f8ca1f9d7ead86ef614a42e950ba7153ecbd6254234335"
    sha256 cellar: :any,                 arm64_sequoia:     "410a9e68644ac91880f8ca1f9d7ead86ef614a42e950ba7153ecbd6254234335"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb87a406cb21aba5c3a32a9bc97ca1093ef2767924398c763965a8aadddabf93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bd18984ea0e8d6781f0468a81a491bee22e154b96ebabaf8e68b0e28fed08055"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
