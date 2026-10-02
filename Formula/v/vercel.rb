class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-62.1.0.tgz"
  sha256 "638a4d8b6944ca6d562f30e3199154288c65ce28b7dd1899a83e3d184c85cef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "cdfb1c1efbf5fa14f8ee78c67d36f431c7135529019781b89e0519897cf1aadd"
    sha256 cellar: :any,                 arm64_tahoe:       "cdfb1c1efbf5fa14f8ee78c67d36f431c7135529019781b89e0519897cf1aadd"
    sha256 cellar: :any,                 arm64_sequoia:     "cdfb1c1efbf5fa14f8ee78c67d36f431c7135529019781b89e0519897cf1aadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "135e53e15dc6042036cf6f1ffafda3ee95b962f5d13e06696a207dbddd32c79b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0dc64d91fc2f479459d60bf2303b0e6c82fe6c05b580ba1c1cb516ef0689f165"
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
