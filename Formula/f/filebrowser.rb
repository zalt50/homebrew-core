class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.20.tar.gz"
  sha256 "c1a5b647395be0a7b719b16b89047ab4e280def9b328c1b377656f139d031717"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c17bf00e1859c7178a46e3b76fdcacee678ef2e1dd112da1d097673d7d84638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "111ae05968ebd07e65cdc3ff05e56e2e73cc43d35b39a53aa336e4803dee0edd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b402594eba02372cacf353d7878274eb9ec2df4c0bf5ca7588b58a61b80507a"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e795220bd7386c011ad5e31cc6749d85c49206b9d3767d129d375bc868522e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4971ada6fd62321b38c3ccd7afbb39660beb025b567f280e6ebdc9087e26220"
    sha256 cellar: :any,                 x86_64_linux:  "1bf94f5717b418ffdc95e170590f80709ccbe24c44fe4dbc716d8f75aaf03b17"
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
