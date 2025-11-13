class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.45.2.tar.gz"
  sha256 "5b8fb1a927334c7de7ba9164684ed8dd88a58c9d2da4dee7ed08ec6f4243d581"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8bcc5f60556563c5bd1441b804a6c69839aea07cd712d90244d19cb4c405d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7056545ea3a8dc11ff035da1603a7a4ee8a34d95ae7d8da56b7cfda1c48bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "854868529abdfeb5d35a0ad4e6800eaa604ab841cd703fa194190f48f01bf2cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b6c6fcbe37af43d92b21a2a0d9592450b16678469d908fded2489f292be6430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8bca2a490187d8f0049c11fb2ab85b06c7dfa10631822bfd6d3ba817d54c24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c44e4d0b65737677741b79f8c6ff406d4abee3881638f6ad4b083be8eade1fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
