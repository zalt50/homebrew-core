class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "73d39f9087fc7638883ccf91509f8e554c2c5ddd7006953df979acf3c01c151d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be9491262ef042c42c5a12825fe1bcd8360e9d5db4766d234846c5a3816d8756"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95d75d7ebc508107659cf8a14607be496dcdd4c9cdd601c775a913229f8e03f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c1898088e0eeaa6375b70c5af248d4408b3de45d90dcc594c32281eb934b514"
    sha256 cellar: :any,                 arm64_linux:       "efff3d3ba5f0abbcb904c18543092b1358b94b8e492eeede762fd1b96fcad985"
    sha256 cellar: :any,                 x86_64_linux:      "b07c8e11de6f026a6cf85c2b137daf1fde190f552eb16d1758878044a1efba52"
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
