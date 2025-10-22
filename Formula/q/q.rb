class Q < Formula
  desc "Tiny command-line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
  homepage "https://github.com/natesales/q"
  url "https://github.com/natesales/q/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "18a68f067daccce97f2a7e4ce4c72e206eba03a1c57040f8c7488f100040d2fc"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/q --version")
    assert_match "ns: ns1.dnsimple.com.", shell_output("#{bin}/q brew.sh NS --format yaml")
  end
end
