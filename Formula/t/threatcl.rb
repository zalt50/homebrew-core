class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "d81b6685e709b1e039365143709466a7f6f330d1784769e027a6aa3417d56c81"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d74ba5bee03f38157e9964e2f0ae4ebdad8bb8431b2e229653b8f2e07e374f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d74ba5bee03f38157e9964e2f0ae4ebdad8bb8431b2e229653b8f2e07e374f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d74ba5bee03f38157e9964e2f0ae4ebdad8bb8431b2e229653b8f2e07e374f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc89076ea69180576daccc4c17217ccdbedf3899f3c6b1ef01441e7ac49f3a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c81579bad4509bfd914f9ddf3f8a581e2d35c4521ffe6b36f46be425438d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04235c92821ad4d000a24b6af2eeae2e57570c83fe85e4f15460186f727a415d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-s -w -X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

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
