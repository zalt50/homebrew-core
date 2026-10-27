class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://github.com/XiaomiMiMo/MiMo-Code/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "dff948e338bf58e7d580a18fc6385f6669c66512e001fa8e08113280d4cab6a6"
  license "MIT"

  bottle do
    sha256                               arm64_golden_gate: "3ac4f6db31b64af97a0b86b47e4fb77dd2840ba6d963fdfa918e02766307360d"
    sha256                               arm64_tahoe:       "3ac4f6db31b64af97a0b86b47e4fb77dd2840ba6d963fdfa918e02766307360d"
    sha256                               arm64_sequoia:     "3ac4f6db31b64af97a0b86b47e4fb77dd2840ba6d963fdfa918e02766307360d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a29562555dc4a9caafbe524ae5ce424c03bd987eda8fc3e13f0e8bf1ab68b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f51ce0b2f58de8c1f9e1ff5a337820a93aeed3cded3b3888db6d467396f11b1e"
  end

  depends_on "bun" => :build
  depends_on "python@3.15" => :build # for node-gyp
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@79"
  end

  def install
    ENV["MIMOCODE_VERSION"] = version.to_s
    ENV["MIMOCODE_CHANNEL"] = "latest"

    # The build refuses any Bun other than the exact `packageManager` pin, so pin the brewed one
    bun_version = Formula["bun"].version
    inreplace "package.json", /"packageManager": "bun@[\d.]+"/, "\"packageManager\": \"bun@#{bun_version}\""

    system "bun", "install", "--frozen-lockfile"

    cd "packages/cli" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/mimocode-*/bin/mimo").first
    end
  end

  test do
    ENV["MIMOCODE_DISABLE_AUTOUPDATE"] = "1"
    ENV["MIMOCODE_DISABLE_MODELS_FETCH"] = "1"

    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end
