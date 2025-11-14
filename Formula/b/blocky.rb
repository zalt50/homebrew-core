class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "28afb06551a0d76790db86a90783abde287531d2dc095164c0bd8647e78bcb36"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "080cfbcbb2df209b4a7fd46ff7451ff01bd8144e8c4d1dc2dea074a34236dbda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e48362c9d314f05af28a0c6c49b340ecf8fa2a3e7d4874079540c2e7c54a05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10498600247bb0a78e23727f039da031f459458dd2d71ecd584aa5bd6ebc5564"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0bec38814801cc0ad1862489392e4827c2eec719ab421b8b3cb66cdfc7fb670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f65f5d48520f29fbd70e187637e33412f0be7b6a5d3dedb7934db823aaa4a4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcfbc9ceb91fd8fdceba5e9995ab456099b72b7e8de1bf2a20c8c0d15b33b489"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end
