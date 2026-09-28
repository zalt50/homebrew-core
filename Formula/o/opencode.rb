class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v2.0.15.tar.gz"
  sha256 "c885dda44b7272dcb5d64fce2d7093b7d73c67ab6524319505c505d704087509"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "6eca0861d2393d59644241ffd768dec95423a62d72fc8d65af66e1bd22565942"
    sha256 arm64_tahoe:       "e6b0af7ecb05fd9a033a3f0a2547c1351ec389ec4b10b1de9ad602bc91319f4c"
    sha256 arm64_sequoia:     "4334a8e50a57fcb38beb8484bc04ccd130cff328aaa414e5a0daea1f6eb6156a"
    sha256 arm64_linux:       "a7ccff3922000524824e102603273d7bf5bb1a04e47c81cd53af67b6a1e5ce5d"
    sha256 x86_64_linux:      "81106fe0486c1347f80ee8b3b255da3a9c272ad460efb0425cfbae9305ddff56"
  end

  depends_on "bun" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "zig@0.15" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@78"
  end

  # Version must match `@opencode-ai/pty` in packages/cli/package.json
  resource "opencode-pty" do
    url "https://github.com/anomalyco/opencode-pty/archive/refs/tags/v0.1.13.tar.gz"
    sha256 "87f86d91eae5b77f9bc1e3dd76c51f85e8c6ff645a60a373f027943557d8b849"
  end

  # Commit must match `GHOSTTY_COMMIT` in the `libghostty-vt-sys` crate's build.rs
  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty/archive/a887df42c56f6de86c0fe6da9c4eeca37931e083.tar.gz"
    sha256 "fb4b2f9ffa0af125983041fdbe4ef94d3fa79fb9f2d22b9c213c0e3847a866b6"
  end

  def install
    # Build the persistent PTY helper from source instead of embedding the prebuilt npm binary
    (buildpath/"ghostty").install resource("ghostty")
    ENV["GHOSTTY_SOURCE_DIR"] = buildpath/"ghostty"
    resource("opencode-pty").stage do
      system "cargo", "install", *std_cargo_args(root: buildpath/"opencode-pty")
    end
    ENV["OPENCODE_PTY_BIN"] = buildpath/"opencode-pty/bin/opencode-pty"

    ENV["OPENCODE_VERSION"] = version.to_s
    ENV["OPENCODE_CHANNEL"] = "latest"

    # Fix server errors when building with Bun 1.4.2 by disabling splitting
    # https://github.com/anomalyco/opencode/issues/48645
    # https://github.com/NixOS/nixpkgs/issues/563241
    inreplace "packages/cli/script/build.ts", "splitting: true,", "splitting: false,"

    system "bun", "install", "--frozen-lockfile"

    cd "packages/cli" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/cli-*/bin/opencode").first
    end

    generate_completions_from_executable(bin/"opencode", "--completions")
  end

  test do
    ENV["OPENCODE_DISABLE_AUTOUPDATE"] = "1"
    ENV["OPENCODE_DISABLE_MODELS_FETCH"] = "1"

    assert_match version.to_s, shell_output("#{bin}/opencode --version")

    (testpath/"opencode.json").write <<~JSON
      { "agent": { "brewtest": { "description": "Homebrew test agent", "prompt": "hi" } } }
    JSON
    # The standalone server listens on localhost, so network access can't be denied here
    entries = JSON.parse(shell_output("#{bin}/opencode api --standalone config.get"))
    project = entries.find { |entry| entry["path"] == (testpath/"opencode.json").realpath.to_s }
    assert_equal "hi", project.dig("info", "agents", "brewtest", "system")
  end
end
