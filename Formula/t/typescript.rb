class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://github.com/microsoft/TypeScript/archive/refs/tags/v7.0.2.tar.gz"
  sha256 "8472f284b1465f5c4826a64c88853eccba667446f31a435ed1d0b28d373dbc0b"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98ddb029b1c72f5cf7fa9463610894919c1ed482bc0550dd6351a85be096d764"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "affa1704c2600fd1b0592c3078f502a5aae315219ad16d2d97cde7ed0f1b9116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "affa1704c2600fd1b0592c3078f502a5aae315219ad16d2d97cde7ed0f1b9116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "affa1704c2600fd1b0592c3078f502a5aae315219ad16d2d97cde7ed0f1b9116"
    sha256 cellar: :any_skip_relocation, sonoma:            "d43d82b4b4666e0efe50f007ad7789cc53caad6398dce78dfed29f339da3d112"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe288fe43e9e26d0c130431d5bf5f4b279f8e2eb12fdb3ad50c3f65b89ab63ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "05916d95ccabec2eb6703a00e33fb2da3cca33e7cbdac8c665523879a01f117f"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "tsc" do
      # Upstream stamps the built package.json with the current commit, which
      # is unavailable when building from a release tarball.
      inreplace "Herebyfile.mjs" do |s|
        s.gsub!(/^[ \t]*const \{ stdout: gitHead \} = await \$pipe`git rev-parse HEAD`;\R/, "")
        s.gsub!(/^[ \t]*inputPackageJson\.gitHead = gitHead;\R/, "")
      end

      system "npm", "ci", "--ignore-scripts"
      # Without `--forRelease` upstream packs the host platform package only.
      system "./node_modules/.bin/hereby", "native-preview:pack-packages"
    end

    cd "tsc/built/npm/typescript" do
      # The `typescript` package only lists the platform package as an optional
      # dependency, so install the locally built one instead of the registry's.
      platform_package = Pathname.glob("../typescript-*.tgz").fetch(0)
      system "npm", "install", *std_npm_args, "--omit=optional", platform_package
    end

    # Prefer the native executable over the Node launcher that wraps it.
    bin.install_symlink libexec.glob("lib/node_modules/@typescript/typescript-*/lib/tsc")
  end

  test do
    (testpath/"test.ts").write <<~TYPESCRIPT
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    TYPESCRIPT

    system bin/"tsc", "test.ts"
    assert_path_exists testpath/"test.js", "test.js was not generated"
    assert_match "document.body.innerHTML = test.greet();", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/tsc --version")
  end
end
