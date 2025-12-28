class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.51.0.tar.gz"
  sha256 "4c6ef41ea15012948854a44d85d6e20d0514c53b77f53464a135ea664186919d"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4ccb850b5f618ac5a9391035f1a6cbe38b41446ee90c1eb2f887b5d2f15616d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a799802563a3bfeb82160b1368a76913e2e019aa7dbed0bcb3dc32423f57a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3050534fc3d1d900984a78129c4bab37800a033ca556780edc59b74c823b64a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f3781cd0342785118a41b35d73fcbb611d788f5feefc3cb46c38d817c591720"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68341e9d8012e42fb665fb7179e80449180164d9e1effd0727059186d28220ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f99cc41f5899ab8662d6c98371508816dcf139355ba52a6e415eb615dc0ea55d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
