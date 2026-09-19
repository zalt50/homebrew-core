class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.22.0.tgz"
  sha256 "8df4ec816f4a078dc2bae8f4bdea8dc814655d8ad0e3f9417e50e2dabc7fc096"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b229da176b0090131e202059c68d54ed0c3386aa5d925e439c7b9db8c4152d22"
    sha256 cellar: :any,                 arm64_tahoe:       "b229da176b0090131e202059c68d54ed0c3386aa5d925e439c7b9db8c4152d22"
    sha256 cellar: :any,                 arm64_sequoia:     "b229da176b0090131e202059c68d54ed0c3386aa5d925e439c7b9db8c4152d22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a5bbdba8027bedae3a05ee26df40086d99d781faf359e33ec3d2cef3156e133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9b26def10ed97a0984038de17a13806c35bdae3ac01648037fef12366402379e"
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
