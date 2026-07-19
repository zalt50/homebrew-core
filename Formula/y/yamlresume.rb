class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.13.2.tgz"
  sha256 "daae042b98995ddb38154c9300e7a114353a8e4862874cb33f2332bc6e7fa7d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16fdc8f567d961850918f0afcea8a00e9df8d126eb56b0a6710eea8c419fba60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e9b149cc16de137f4d7df2acae0602fb4418dccd031a06b8e65d66604797177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c5a01405596f42aa7c5581e81c89d63a9ef51011f398a79089a27e133ee9a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "024ea842581ed9f6e07eb13e0897403cca6e526733d2fa5c9f6a4657e7d93073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21bc5e0baf1e30ef89ab1eb3900c7a095126bd3bf67f247a5aadc117a1334c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21bc5e0baf1e30ef89ab1eb3900c7a095126bd3bf67f247a5aadc117a1334c33"
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
