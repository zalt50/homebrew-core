class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.5.tar.gz"
  sha256 "f2518529b4bc1eaff5bc1d2cfefb598d1a4ea6cf577270a6a89de1bbda1154a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47c8e6c8de838fe3e0ced236a9fc492155470011680a378ba5d967ef59a18e84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3618ef1db9ea37babb35e9ab177dfac9b299140c249040508b3364e95959dc2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9077d979643b199610a385525e853c4de39a114927cb06c4347947e8b19dd60"
    sha256 cellar: :any,                 arm64_linux:       "0baf45d3f7f4ca3bca7ec0afde22c183adc62e09cd94c9c72c456d8dca06aa04"
    sha256 cellar: :any,                 x86_64_linux:      "118640881640929d82faa466bc07e91044ea5fc471d6c06519e7c9dfbde49619"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end
