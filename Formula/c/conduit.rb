class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "b865c46841ad39d477f7965e470a3e18960525916aaae40485ad9f410b42f2a0"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3451f42af8e8f0fd9dc7972ab8af15713490fd599e8410753f06896d4b65b167"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b63558862b032db592fe0f859464ea148d6dafd450e319d9f5586a71884bca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfa0e0a5974c6bb215847c96fc10fb936b062ca289d433c8d7a95f59e7cbafdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1cd99c70dff2e8ff5c8c6687fb0d3c5bf9b3320e8d442ba3e1d03c6766d24aa8"
    sha256 cellar: :any,                 x86_64_linux:      "ab22d0d804688100142cc8c4ba2257abcc3c2db81bd516ce0f4fdf0f6a8dea59"
  end

  depends_on "go" => :build

  # Fix build by reverting a half-resolved merge in pkg/lifecycle-poc/service.go
  # PR ref: https://github.com/ConduitIO/conduit/pull/3285
  patch do
    url "https://github.com/ConduitIO/conduit/commit/b3c9ccd27303573df3afe8f39bddf541c48b76b7.patch?full_index=1"
    sha256 "74f6abb271f04f5b8e874e09d055ce76dc6c4500e5dc7ff8a5b8ffbb790d5e9d"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Drop the test files the revert patch deletes but `patch` leaves empty
    %w[pkg/lifecycle-poc/archv2_batching_boot_test.go pkg/provisioning/boot_start_test.go].each do |f|
      rm f if File.empty?(f)
    end

    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", "127.0.0.1:0",
                                 "--api.http.address", "127.0.0.1:0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
