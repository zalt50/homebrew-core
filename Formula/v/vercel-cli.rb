class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.1.6.tgz"
  sha256 "bda1717176eba0ae9484c5d1687294d465885b7cdf9f5a26fd166e2bacf7d048"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f2700cc3e6e50035959eb429b774cf83984faf4aa3bd827e032cf2224f1d096"
    sha256 cellar: :any,                 arm64_sequoia: "57e4f36a7a18d37a7e0fbe22b94fda4e8e362b3a5d67bcd878fa5525facc61a3"
    sha256 cellar: :any,                 arm64_sonoma:  "57e4f36a7a18d37a7e0fbe22b94fda4e8e362b3a5d67bcd878fa5525facc61a3"
    sha256 cellar: :any,                 sonoma:        "87f86ec427fd45290ac46db747ffab7de018b2562dbe1a20928ffefffe0ecdf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "575f4f69665d9a5a98eaabb9e073c48651e4a01e5c4e83a4fd63925508cd2574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19c7a19a7a7333a190d06196166956cc0fbf023863b33fe3a16abfed29ffecd5"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Rebuild rolldown bindings from source so the Mach-O header has enough
    # padding for install_name rewrites performed during relocation (macOS only).
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.mac?
      cervel = libexec/"lib/node_modules/vercel/node_modules/@vercel/cervel"
      rm cervel/"node_modules/@rolldown/binding-#{os}-#{arch}/rolldown-binding.#{os}-#{arch}.node"
      cd cervel do
        system "npm", "rebuild", "@rolldown/binding-#{os}-#{arch}", "--build-from-source"
        system "npm", "rebuild", "@rolldown/rolldown", "--build-from-source"
      end
    end

    # Remove incompatible deasync modules
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
