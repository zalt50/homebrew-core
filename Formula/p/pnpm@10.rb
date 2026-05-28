class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.34.1.tgz"
  sha256 "b568bc5ee2b68a9735743c1b9f09b3d3065de64befaf186c5d01b2f084d16cc0"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d3c94b08d74f73925dba58653b3291d671b965c0c72e60a7f4255d3dc8fb7e0"
    sha256 cellar: :any,                 arm64_sequoia: "6a0139c02f67f639a7c9b4753e75595019166fa281ad2b249bfa329be52e87fb"
    sha256 cellar: :any,                 arm64_sonoma:  "6a0139c02f67f639a7c9b4753e75595019166fa281ad2b249bfa329be52e87fb"
    sha256 cellar: :any,                 sonoma:        "0128b4702c7102985bbe8ce7b92ecd4d5540a29440fb2dd54a97f89b49f0d77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a11bd84c19dae942afd17e89561863acf0b11e4d9d0a281e13e7445756015a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a11bd84c19dae942afd17e89561863acf0b11e4d9d0a281e13e7445756015a4"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
