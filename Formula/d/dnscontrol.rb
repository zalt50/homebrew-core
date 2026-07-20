class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.43.0.tar.gz"
  sha256 "0b66327fe85509866393db08297aa320bf6e81e364c38738f96bdd06391049b7"
  license "MIT"
  version_scheme 1
  head "https://github.com/DNSControl/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd9ca2d1287f1cf4b9184b64294c86f7a366fd714ea99aecdfc96e0ae90ed9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26bf927ce5f4b096c4458ac506d5cfb27fd9fc9617a0915376d079a991258790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "536e4eb355f44b15bce9c9fbbdac2f67f632b5e0633b990f68987c7015bf36ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "41be0627c28d77c900f7243a39eef6bba5e31e9769d2cd376a5985f8f5210e84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9865a2c0f72df97a2b6f8fb640363723af792abdbc9c28a56452e410caf45f4"
    sha256 cellar: :any,                 x86_64_linux:  "985b06b6721c91387576f1751d90119bcf3a5f766c4781319a52262cf5866a4d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
