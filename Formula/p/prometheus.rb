class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "b97651c0aa00d0f6fd2973b773b18d31fe0402a4ca75b1eba7e788d7de42c9c0"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "515543c2526b2128f17376759028bcbe85e27980f47c7a5f609f2e109dab2f6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfddf7eca08269c3a102c6c19e2062ce404de67cf8759f5e49228ca392378a81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6116cbdc352dea83865b3470c0bcb59294c1fabee6824719243112f48cd32e"
    sha256 cellar: :any_skip_relocation, sonoma:        "087d7e0fb72347b7a34ad88e9aca4d1d29dcfe0044672d29c62c42329a2028ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac1f7a698e695c0f1cf0728ce24b95ea0e176aa96556e3087e479f3d07bc288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2560ccfe076537c1d13c7b10c3c990ad17262c768d9fed23806cd6c0c8bc43c7"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~YAML
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    YAML
    etc.install "prometheus.args", "prometheus.yml"
  end

  def caveats
    <<~EOS
      When run from `brew services`, `prometheus` is run from
      `prometheus_brew_services` and uses the flags in:
         #{etc}/prometheus.args
    EOS
  end

  service do
    run [opt_bin/"prometheus_brew_services"]
    keep_alive false
    log_path var/"log/prometheus.log"
    error_log_path var/"log/prometheus.err.log"
  end

  test do
    (testpath/"rules.example").write <<~YAML
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    YAML

    system bin/"promtool", "check", "rules", testpath/"rules.example"
  end
end
