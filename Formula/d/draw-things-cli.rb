class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v1.20260430.0.tar.gz"
  sha256 "c8b8fd0f1de3d8e4b05bbc2f0f19cc507b871f86eefa6b2da26b4aca9357f9cc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f78bc2923d686904e2afd1fc03a22ec4c02f56acf10eafb10ff10cc32dda313e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74cc982f3134a1b0d0d8d53a791e876357961a862af9196efaeb1025ed3b63aa"
  end

  depends_on xcode: ["26.3", :build]
  depends_on macos: :ventura # needs CoreML and other Apple frameworks

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "draw-things-cli"
    bin.install ".build/release/draw-things-cli"

    generate_completions_from_executable(bin/"draw-things-cli", "completion")
  end

  test do
    # Point --models-dir into testpath: the default location is outside the
    # test sandbox and depends on host state (Draw Things app container)
    models_dir = testpath/"Models"

    list = shell_output("#{bin}/draw-things-cli models list --downloaded-only --offline --models-dir #{models_dir}")
    assert_match "No models found.", list

    generate = shell_output(
      "#{bin}/draw-things-cli generate --models-dir #{models_dir} --model test --output . --prompt 'test' 2>&1", 64
    )
    assert_match "Error: Could not resolve --model 'test'.", generate
  end
end
