class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "dfec82cafa84a652c4a0a991f2a1874bcb9918d08ffa80b4f937e1185b24345b"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecb516dbffc6da13dbd08c91449238b90c1696fb2142d2a87241432bdf94e538"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb516dbffc6da13dbd08c91449238b90c1696fb2142d2a87241432bdf94e538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb516dbffc6da13dbd08c91449238b90c1696fb2142d2a87241432bdf94e538"
    sha256 cellar: :any_skip_relocation, sonoma:        "b57eb7fc28f1a16825500cfb2bb9c7b0ecd745e2d22981d3edf9379b23863286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7267266ef9eea8b17d9027a129a0dd286b7eaf665aae248b994f094b0c6d7b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0b4c6c2428a967fbcd863e72884e6fc7fdb038af3a89ece3c3f15775b68711e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
