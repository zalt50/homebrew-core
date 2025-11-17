class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "0be8473755ad90877f2e0b6ba807ff40d5ddd952dae653b967bff32dc58dd4e7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ff9dd959783bf4ac5b4e2c69fc554955c5b63cc5f3f44c5d2f055c3fd830a1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9456c63a2f312a3bfd37f46e1112fd2e697a9ca7e85b0ff2b67aa514eab371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc2d5aca8c7ab066c55e622c93d1c407ce3bd885fc529ea6c8faa540c3a7149"
    sha256 cellar: :any_skip_relocation, sonoma:        "9225f8514fc44e09a21a594ec6ebf7222651f64ea6e72d5cf79d871bc534e632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ec415c368f69d244358938bf42c67b6f67ab949c7ab8045e171b446d67c71d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40ac0c3c6fde8b1be1b1630d58bccdc5b0237146cee34f9d5963d1157ec2814"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 8

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
