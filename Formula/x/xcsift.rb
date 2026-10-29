class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "f2b074654d3125166870b041da34d5fcc75db0adff54e6e0d952cb8caa3f5975"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f7ae2aa8f384cf8553060293e2fa6b5d87bbdde82ad3c58d0e03e9b1b51c191"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7f5ac3889e178b6be3ed2204d6274df0ce81d7d56ddca84ed16de67ad1168fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c895f540de06d3cd343215d68ccd05748279e95397fca36cae27617657b0241"
    sha256 cellar: :any,                 arm64_linux:       "48c3ffb52c987460472384dd2499f1f1f9d32e9fd3735396724238bde84ff1ae"
    sha256 cellar: :any,                 x86_64_linux:      "dce16b4f7d0fd23b4c8f36912868fc7c0d0a4f3719e016fc798353c3d5143e63"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end
