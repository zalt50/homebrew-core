class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.23.tar.gz"
  sha256 "18020983f6a4e43d679738738c3f95c52a333a282144046ec152491f2341a152"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0163744b72d4320775da161de7c9ff4e549d791d2ea5da6bfd739bdfe9c47933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5189b383882af1a226a7a361e7e17a766fbd74fe2e0962f2f11336cbbf8f5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21abf6d3f7420e5d2a9e2bbf616127b031ae572a128891b13bd09d5d6dbf9486"
    sha256 cellar: :any_skip_relocation, sonoma:        "531edec0cc1959a90fb663831e028c4836b306b95a5a7e0e1e3ac434a9e67a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4d3e443eb75aa259f85a86cd8476001bb57bf18c8d62fc3166bc280747f12b4"
    sha256 cellar: :any,                 x86_64_linux:  "bd3009e677247ba04506cf6e11b3d9be168756b5bad7b14417c603fb1360b52c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
