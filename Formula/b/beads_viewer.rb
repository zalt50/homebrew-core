class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "ab22edf73e57f9b53a271f75753e6b6f2d081a80ba8318eaaa388a3ca1969679"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "083f89ca6f2f2f8a41f441416b22050306523f46747826450927f394a8674b85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "083f89ca6f2f2f8a41f441416b22050306523f46747826450927f394a8674b85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "083f89ca6f2f2f8a41f441416b22050306523f46747826450927f394a8674b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b80f044df8155b9376ab69f073e4e329de771676a7f78fa56129c13d1e18f6b"
    sha256 cellar: :any,                 x86_64_linux:      "4bd154194301e0cdebcaeca3b73f7887c8a688601e1ac9c42cbacf0340552f1c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Dicklesworthstone/beads_viewer/pkg/version.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
