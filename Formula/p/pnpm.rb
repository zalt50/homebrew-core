class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.27.0.tgz"
  sha256 "d3c7c3d12d87d177e32f01748d5994fb20cd5becf11670ee60530c374ffeabb3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bae62ae35632518f5d49b91c427e86163a011f4f079e104da9c335921e404e9"
    sha256 cellar: :any,                 arm64_sequoia: "48f96b4f7e2f696c1cb8b3bcba10e2f4ff99bcf7091f0db63a991af39e870114"
    sha256 cellar: :any,                 arm64_sonoma:  "48f96b4f7e2f696c1cb8b3bcba10e2f4ff99bcf7091f0db63a991af39e870114"
    sha256 cellar: :any,                 sonoma:        "12cfcd7039f88f763af679f9c5f00c779434e1ba5fe490445c900334200c3a39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f119ffab0e61dff91286024ee025981a6fda43c21ce52e2262f27e506da9fb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f119ffab0e61dff91286024ee025981a6fda43c21ce52e2262f27e506da9fb3a"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
