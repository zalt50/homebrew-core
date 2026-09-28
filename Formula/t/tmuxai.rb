class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "7713f52ce96ac968821b28d5d324719fabd9780cd31a9ff04f95d359d56593f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd6c2743ea85b2054a12f0a54b5c583c8bf158c118fd5afbe9b256bc2baf45b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd6c2743ea85b2054a12f0a54b5c583c8bf158c118fd5afbe9b256bc2baf45b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd6c2743ea85b2054a12f0a54b5c583c8bf158c118fd5afbe9b256bc2baf45b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bd6c2743ea85b2054a12f0a54b5c583c8bf158c118fd5afbe9b256bc2baf45b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1df88425041640e0a2ff4a78e58ac6b4af158a0550cea50a3d6e5be1fd17e506"
    sha256 cellar: :any,                 x86_64_linux:      "8445064619775459e3e48f0b2b01beebd1548a117871097a64bca2bfe72c894c"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
