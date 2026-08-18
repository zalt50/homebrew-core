class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "74c15e1c16854747be4f62f00320abea0fad41045559a8e43dd9d301a41455ab"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93b572ec420f8f56fc61f564ea6aa53b7253141c274b035d62a345976e79a07d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93b572ec420f8f56fc61f564ea6aa53b7253141c274b035d62a345976e79a07d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b572ec420f8f56fc61f564ea6aa53b7253141c274b035d62a345976e79a07d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f151fc0de5dca0647370691c3862155d82a927b4077b36aa5f4d192a5c830e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a98066e53b71be5d444486caf424bd574361ae805ad2baae6a213f50d6c540f6"
    sha256 cellar: :any,                 x86_64_linux:  "f1a1a32670d2246707e45ce21c42de2a4938e55e94c1824de33d773b19cc7c89"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/betterleaks/betterleaks/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"betterleaks", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/betterleaks --version")

    (testpath/"betterleaks.toml").write <<~TOML
      title = "test-config"

      [[rules]]
      id = "custom-secret"
      regex = '''SECRET_[A-Z0-9]{8}'''
    TOML

    (testpath/"secrets.txt").write "prefix SECRET_ABC12345 suffix"

    report = testpath/"report.json"
    output = shell_output(
      "#{bin}/betterleaks dir --no-banner --log-level error " \
      "--config #{testpath}/betterleaks.toml " \
      "--report-format json --report-path #{report} #{testpath}/secrets.txt 2>&1",
      1,
    )
    assert_empty output

    findings = JSON.parse(report.read)
    assert_equal 1, findings.length
    assert_equal "custom-secret", findings.first["RuleID"]
  end
end
