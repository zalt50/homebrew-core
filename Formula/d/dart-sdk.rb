class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.10.5.tar.gz"
  sha256 "d27a0f943c4418adfe6ed1bf6f32a193f4c2f456c79c97df0177db4f7bfe2ef1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c5e4b33cee9deb59b6498026a02f1b4975c6563c9023250248654c7de5d4e63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f42030530798cd0ab20de929aeb6aa813159f5ad2cbb2af988df7cfabaf1647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b67f14efc3482848ee9a2d010a757177910ff9c23c487195cb331919f707dbed"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfadc7e47ea079d3892d1b9d91c0157308f16201a1bc80a0cdb0287cf5b1bb8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fcae4c10bdade822d75a554144e880a64ab013195b9bd05178060892b18ec1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c0652c44bfda332127e6e2d28b51d14a940c6540f96232adc9506d5cc2c61c"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d29cc8d7bb26ed24637242cc94cf57565ea33042"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.upcase}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output("#{bin}/dart run")
    end
  end
end
