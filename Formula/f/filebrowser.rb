class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.6.tar.gz"
  sha256 "c45b16506038f29a5d0cf89c824fd7148d4a6b2e1909cf5b156d664ae8eab4fc"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "542b6526fce069c480cbe03c3a8220ebfad1ca479bf53ab5f448bc4cadf217d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a59c66dea1287981d68c157ea81118fdcc6b2f5d1e090c0e668c66e4341bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ae33a444a58cfed430ab7a6de6645e635b2eac8f20f8eda2d58a6a610f44f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6efd6259dae9bb16e85ea7c79e33b880952d39dcfe3ce31745babdedb6eeea72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab2c3cc968ff0bfb697665f78ff7da89999fe6f97981a51a013d6916c003ec4"
    sha256 cellar: :any,                 x86_64_linux:  "0017679c99c89a2c102559d69297a1c236cfbfaba346ad0f357a7a4f68291661"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
