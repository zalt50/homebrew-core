class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "3d8e8588fa653ee6c7579a1707b95231d6dc18e70f503a0f8b6be5553230f40e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b7ae00df26c7092d5d230d694d2ff6ef59e7b1f880f735b9a21e4032cc6ef1cd"
    sha256 cellar: :any, arm64_sequoia: "889918236a18c1f3e635cabc2503dd299264a49f9ae7c81a44aea49d3fe11d7e"
    sha256 cellar: :any, arm64_sonoma:  "7ddd0698ba9509227bc199c6e46a60fe2ef74e7ec6008c8c845a53422c0adbd7"
    sha256 cellar: :any, sonoma:        "e6f0dddee0e53227e05c756c543d80faea5d7880cb86b53291c3407088fd7265"
    sha256 cellar: :any, arm64_linux:   "dc363617c842bf4f4b6ecb1939de9ef7ef8f86b749ee2c0da71f4a2ee9eb6e49"
    sha256 cellar: :any, x86_64_linux:  "a1545b5de4e7d2431578515ee72f618ad4e1aef08addfda0c18b2cb60bbcf6d8"
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
