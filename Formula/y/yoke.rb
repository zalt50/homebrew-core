class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.25",
      revision: "e096a8a369f0db1826888eaffdf4aa2976d6ff55"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79bdc51435f18ac3af9286a88a0a5782fa9d4f462c358582b40852922435bae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c90b5ed483731bbfd05bdfb5ae7eb99d704a6289b01d91c27fd85ae7a195c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7249bb149244f8b2336d7fb21d0bcf42c4f99079655244fbd5e82f66a5adb474"
    sha256 cellar: :any_skip_relocation, sonoma:        "85c2fa94e45be41c033dafd779c6210460984976b5497077f7c087e0f8e72673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec69df26f0e5a04821df959781b2cf9bcb97379748eb3dd080eefe4f1b31f9e"
    sha256 cellar: :any,                 x86_64_linux:  "78edddc5092c9d320dccaa26d5a5cd1660a92a525dc807e8a008ec4dcd7b59d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
