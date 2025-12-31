class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "07cb0c8ca40ac2453ac2eeba1acd64f586a651b414cfc6af2cff739630dd9f77"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b864725d2e5d7ffb8f17293e90c97a8abb6573e14fe5d9113427fa355a0aceb7"
    sha256 cellar: :any,                 arm64_sequoia: "700a63b9b288cac4b3ad0d3081837132d98ff0d901b7662547eff3ff3a9b2225"
    sha256 cellar: :any,                 arm64_sonoma:  "7e63960af9615c110ec7fa32bef44e4ea89ca3179088dc9eeb26b7f42d3304b1"
    sha256 cellar: :any,                 sonoma:        "578aefcc57ce8578af310d53fd34fcbd559a947a6b80734b30f45f5b33c48a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04ae16a81cbf845ae8c1f220afa11d48a0c31974ce4f5685fc2b9ded3f400673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32dbce8f89d748725fef527dd6dee17094af4a8ca1245392be30dfb1dd25fa2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
