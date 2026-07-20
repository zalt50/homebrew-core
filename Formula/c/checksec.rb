class Checksec < Formula
  desc "Security feature auditing for ELF binaries and Linux kernels"
  homepage "https://slimm609.github.io/checksec"
  url "https://github.com/slimm609/checksec/archive/refs/tags/3.2.0.tar.gz"
  sha256 "3ea46986821070ed06fef5215b2a83a9076115a865da70874e19f214db2c8d83"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"checksec", shell_parameter_format: :cobra)
    man1.install "extras/man/checksec.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checksec --version")
    assert_match "Partial RELRO", shell_output("#{bin}/checksec file #{test_fixtures("elf/hello")}")
  end
end
