class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "7914e09ee966e7498c4a0c365590f555c741c24b1dee022f60a2284036c2653a"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40e74095c993f35604dfc623f99570c7c1468983eda31ee4a7d80bff8513bb8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e4e70597b1f5e45ce815ad0612fd3a93e046502a1e1e38116b7632a54bcf50d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e4e70597b1f5e45ce815ad0612fd3a93e046502a1e1e38116b7632a54bcf50d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2e4e70597b1f5e45ce815ad0612fd3a93e046502a1e1e38116b7632a54bcf50d"
    sha256 cellar: :any_skip_relocation, sonoma:            "1f5af17e2918b7cb2eebdd8f7965115716a837fc398182d4bd9dc123ff1bd0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e6aa077cbc9cbdefc7e8bc774b9d1b9322b4dac24f035da678f3bd42a84690ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7db8cf0a58bbad28267d15f4d8219de4098115afd38180586e4491d555c72eea"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
