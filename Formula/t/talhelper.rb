class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.16.tar.gz"
  sha256 "506b53442cbaa3ea34990f182d2db206d6987d7ae3652f91883ab6358af6b2ee"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56e04ec0dbae7c2a1980ef588c10fb6f3d8e50964e6bfda6c20d95ff3e919e4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56e04ec0dbae7c2a1980ef588c10fb6f3d8e50964e6bfda6c20d95ff3e919e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56e04ec0dbae7c2a1980ef588c10fb6f3d8e50964e6bfda6c20d95ff3e919e4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "656d0084c1ab3d3e4cd85a00a995463af863bea6627df9429cc5561d3b32d070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1066ceb365084059bf4beb6d0d0a91ab9e2fd9ed948d8898f4995974ea1ef5"
    sha256 cellar: :any,                 x86_64_linux:  "4657c8aa233c099dcf8e58827041cb515b2905e6ff5c16d6ce1ac73051958b6e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
