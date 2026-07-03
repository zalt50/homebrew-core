class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.36.crate"
  sha256 "1287da2a83ab27b0a16c1de6b30fd9d825630f1b3715b45ad3896af50c49cef8"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93051ba76b581dc7eec66529b87123c070c079fde0f8089c198c68ae47bf2672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54c34e206a545be2262654000cf339da7e9a0382981af15847e7d85361f8a255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53f65f50b809b09a5270704176935a80a9a2359458d2c15b89d1a3081ab76521"
    sha256 cellar: :any_skip_relocation, sonoma:        "32632b2bd7ad9e15dd6a5697fcd54aa02bd5fb72872f433a458411bed24dd98d"
    sha256 cellar: :any,                 arm64_linux:   "e2f1f90b0668e44bb3d27295d3d2a89e6fea9dee9f803a25294eb89e486b517e"
    sha256 cellar: :any,                 x86_64_linux:  "f197fbd5b49ddb1107c308130c191f35c41cfd0f69830e870f49eeec80e3e76a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
