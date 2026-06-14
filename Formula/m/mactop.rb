class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "df49979c413b8a3a6e98ccfb553fafeb94fd652ec13a830205d057c8d73cace7"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "828f63b68bc39cc6ee04235357dcd8e9187faaa4153504ebefac80e05dbd2672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47d1b54c5b568a6f01c9391162cee6f3165740547f6959fbb71d84aacbf61fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9640633fa24896e827b27bc2104c6dd9071dbb0ee0723b084a180a4593d64d40"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"mactop", "-p", "9101", "--headless"]
    keep_alive true
    log_path var/"log/mactop.log"
    error_log_path var/"log/mactop.error.log"
    process_type :background
    nice 10
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
