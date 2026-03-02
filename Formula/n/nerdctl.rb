class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  license "Apache-2.0"
  revision 2
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  stable do
    url "https://github.com/containerd/nerdctl/archive/refs/tags/v2.2.1.tar.gz"
    sha256 "f39c34d3a285e087f2b2869f06fea343d8285ad9bfb9417b9c5b6dd4e78d6fad"

    # CNI: add Homebrew's installation path
    # https://github.com/containerd/nerdctl/pull/4761
    # Merged into main, targeted for v2.3.0.
    patch do
      url "https://github.com/containerd/nerdctl/commit/a1cffd64ccc1ac6c261f10937e3b3fa57ccac90c.patch?full_index=1"
      sha256 "667781729c9225e28fe9ddb2ad32e7b46f2bcfc62b5ef95e5e9b592e0c221414"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f56a55ab70d05398e06c6c542b2a03e5d80424c3dcdb1c1263b5101d0c07f0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c99ebeb05ea37c502feab10d6b1571e380e2f3adbcfe9403ef6b73913da7784"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v#{version.major}/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"
    bin.install Dir["extras/rootless/*"]
    doc.install Dir["docs/*"]

    generate_completions_from_executable(bin/"nerdctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
