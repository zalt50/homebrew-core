class InstallNothing < Formula
  desc "Simulates installing things but doesn't actually install anything"
  homepage "https://github.com/buyukakyuz/install-nothing"
  url "https://github.com/buyukakyuz/install-nothing/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "de1afd428496e8d7228e2023104613098808994b0c3859565fd02d41e86928f9"
  license "MIT"
  head "https://github.com/buyukakyuz/install-nothing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d05581638eafddfc56a2f41180715f34dfb094bb799aa2525094521527a6c013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fb99f8d2b3accab51ab063f0b5b9fdfb364f1af4e961ce17bd9f0d2593c5f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7519bbe3818011a65dd4a7cdcaf3901f66a54d19bfc1d83e360fb93791d69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "940ec025c1db211ad1349fec32491779ab3093e83e21b41f64b6c5118c6783f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7ed94bce128d4cc351bda6209635c5bb35471d8717476a0b28738aa37049d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec6899a862fff009024a70964069c35fcbbf52d652b712cd8fee199f446e8e3"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, ps://github.com/buyukakyuz/install-nothing/pull/14
  patch do
    url "https://github.com/buyukakyuz/install-nothing/commit/1933dfd5ac5f8e6572b6cb0d8fde8b152fb51540.patch?full_index=1"
    sha256 "11ffb9c283c1d38933de854468b2f6c6001aa5d4886961a7372dde3ea602d44d"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # install-nothing is a TUI application
    assert_match version.to_s, shell_output("#{bin}/install-nothing --version")
  end
end
