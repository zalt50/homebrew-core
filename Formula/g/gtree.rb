class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.9.tar.gz"
  sha256 "fbedb935bacd045e67a2d91402fa441da0824ff67941bfb5903a653db817e623"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c4ca54afeaeb28a47a6d9dcef5a46c9ed7a508fe5cb92ae756e98209601b62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c4ca54afeaeb28a47a6d9dcef5a46c9ed7a508fe5cb92ae756e98209601b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c4ca54afeaeb28a47a6d9dcef5a46c9ed7a508fe5cb92ae756e98209601b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3cc49d65cd112578d46916488a8a320d9a09f169e0083003e2ccf58c424fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63975fa85ea6f9f57d6b4e980b0e8f5126d907d32c28518a279847779144ef74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b33f285929c1551d4339259b1157276f015fbc8c23579b2192a15266ba25e7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
