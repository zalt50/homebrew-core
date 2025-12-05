class Papeer < Formula
  desc "Convert websites into eBooks and Markdown"
  homepage "https://papeer.tech"
  url "https://github.com/lapwat/papeer/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "bfa5ed66a3622b51b3462a629b01327d335bc56716f700ad97a5f4b521bcb94b"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"papeer", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papeer version")

    output = shell_output("#{bin}/papeer list https://12factor.net/ --selector='section.concrete>article>h2>a'")
    assert_match "8  VIII. Concurrency", output
  end
end
