class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "563206ea6c849b774bb518ea2ffe39461ad7aaa9061ce179cf44faf3df476835"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9794b0451881c749c2967a43f89b887f22be9541e7b845f90a9edd5b98114cce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "132c47ed780522b6364778f82be85dc35418ece7a3088f88a2592f9127a6ece4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "492e61417128ac2b11d990adc11bc1b7835ca42ff519ccee716b39c3ab30f062"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7642835cd9e05b72934cc3f5ae0a628517104d3f13ba8108bd992c1abb8abd1"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end
