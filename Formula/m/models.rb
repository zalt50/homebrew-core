class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "21875d403fb3a926368f46d4a503875db490bc366a95d04d8adce839001de211"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68e5f5cb3213e529710735450d10fa13be2955c57af79e1d1ef0516d79a7b75a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e08771554300abd7f64dc2a8d515db9da402219973189386a391b95412dc422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8900921b53b2d1af5899c94995eab2d0f858521e662852fecb5d8cac021ad1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc654eac6d060d8005a9d268e0857ba999a4922bed5e8204497a9d869785d7c2"
    sha256 cellar: :any,                 arm64_linux:   "22264670a32bb1f8a16bae68aef3f55fdeb1f6ec0ec02446e130bc7df1e07a70"
    sha256 cellar: :any,                 x86_64_linux:  "a515506080a6ac7cfe7200c0b33e88ae8c76691eab2c12fc23898282a3296171"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end
