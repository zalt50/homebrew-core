class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.13.1.tgz"
  sha256 "e540edb16b1d56ee86e137a9ae6fdf0c970775c4d5c41cb8b8c5f0fc95209f2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "875e7900d381a96c6db2310bd636bcdea1d014b603f19de4f264b0ecdfe97de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e6f77e0a31318046c7bba174633d348faec175a0d8d87ec7ba78517a89f06b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47632c25d7e7b0f2b8b3567ab2f16f9e94e58f408e8a7595dba8d7b6d53c614c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf6d2232f551776e4bba98b9ce1526c4ba08bc8a38ef6c4b39d5355aeb41fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e17fd43616949e86cf9e3c85d9c3cdc777a603d444b66b3d76c6b95bfd665e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63e17fd43616949e86cf9e3c85d9c3cdc777a603d444b66b3d76c6b95bfd665e"
  end

  depends_on "node"

  on_linux do
    depends_on "fontconfig" # for font-list to run fc-list
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    # Replace prebuilt binary by compiling based on upstream build script:
    # https://github.com/oldj/node-font-list/blob/master/scripts/build-darwin.sh
    cd libexec/"lib/node_modules/yamlresume/node_modules/font-list/libs/darwin" do
      rm("fontlist")
      system ENV.cc, "fontlist.m", "-framework", "AppKit", "-framework", "Foundation", "-o", "fontlist"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
