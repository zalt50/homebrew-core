class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.29.0.tar.gz"
  sha256 "61d8ba871d2ff1d815bcc549e33c9fba283de8dfbd7e1c716161133c1fd485aa"
  license "MIT"
  version_scheme 1
  head "https://github.com/StackExchange/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4bbcd9d77da93123bd11e8777dbb960ca32db4d2abf9d68b79e1fb09f7fadd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6e04694281dd9cff3d336dce9d1084004e59888d4bcd670193e39f1523e708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88bd26dc209134697d0c10b74a8d83380447ba1252adf51d69e8b54f8757a22"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdbb9e723b45d0e7325b076c7fbe4640418585c7b23c77bf2717449937c96a89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d840b58d30a9448199c5f48a89a40771fc37ed26a5b825481880f1ad7d50d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40be4c93db519f9fd2400e23afcca70554fb0dab33d2feb0bbb369d8ecaa2c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/StackExchange/dnscontrol/v4/pkg/version.version=#{version}
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
