class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.20.0.tgz"
  sha256 "34c44a6a14200f9d9f0b2199195cf34a0e5ef2db241a65930324b692306838e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f8423a998da50446a49398dba5e4afe75c7bf5e47f9313d22fb2411402e562b4"
    sha256 cellar: :any,                 arm64_tahoe:       "f8423a998da50446a49398dba5e4afe75c7bf5e47f9313d22fb2411402e562b4"
    sha256 cellar: :any,                 arm64_sequoia:     "f8423a998da50446a49398dba5e4afe75c7bf5e47f9313d22fb2411402e562b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e10d44ac9fe989d4c01735763956302845131126586540e5a01d0863145f258b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "79527e6dc654c9421aa7fb092270a045c3e568ea46f291bd80daa50fdc0ddb8e"
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
