class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://github.com/wait4x/wait4x/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "36b1e0d3e7894ab20d29dfed19ec306c19e94608c2cb1a61ef5084d5127dfca8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94dbcd9c043ccb0ad632e163f1b4f4b367315747c4f57beb3fca90823abda2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b5a09cc37f72ce471b70f04633b21e18aa4a175baba290ec6b720401733a3da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ace472edfee41bc10175e5e8a780bea7f09610bc3e60554239f19eb148108bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "315763a5245e4ad66ae9ad8035c838d574946495e55636bb2f92f876680e90d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ddd328c783ff1efbe28b2425c2f4298752acbefb6c77e735c791359ab939fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "672521b4ce64da9a884e278fb31b1c974710750306f51e63b0c366478df08333"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "dist/wait4x"
    generate_completions_from_executable(bin/"wait4x", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end
