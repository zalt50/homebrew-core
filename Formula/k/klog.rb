class Klog < Formula
  desc "Command-line tool for time tracking in a human-readable, plain-text file format"
  homepage "https://klog.jotaen.net"
  url "https://github.com/jotaen/klog/archive/refs/tags/v6.6.tar.gz"
  sha256 "78579e2686de8973fba005fcf510e6c382b80c674527ca55c362ed4317897b3d"
  license "MIT"
  head "https://github.com/jotaen/klog.git", branch: "main"

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
      -X main.BinaryVersion=v#{version}
      -X main.BinaryBuildHash=brew
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/klog version --no-check")

    (testpath/"test.klog").write <<~EOS
      2018-03-24
      First day at my new job
          8:30 - 17:00
          -45m Lunch break
    EOS

    assert_match "Total: \e[0m\e[38;5;120m7h45m\e[0m\n(In 1 record)\n",
      shell_output("#{bin}/klog total #{testpath}/test.klog")
  end
end
