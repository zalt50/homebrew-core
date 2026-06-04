class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.11.tar.gz"
  sha256 "b0037362d7841cb9cf89d998878daa41c574370d4f089f2f5abda9b4f9b1ad23"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91fc88dbf8e5c8aecf1f1cf982811eedfa1f7a9d802a6a7057721bddfa8ac94b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77fd6b593ecddbf748daa7a5504aba369ebd1d0af085b852c973b8cf61df838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ace5458bb2c764efd47d29e9eb89e7b59f99120766ea6b1eec0ecb6d5b124b"
    sha256 cellar: :any_skip_relocation, sonoma:        "34bf57f4bbedf39066a4ea93e40149677bdce7cc3afe3abea024ec61fbb28d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8ef91a6881c39bb748466091cee93b143503117b5887ef8f9a1e9327b62c3db"
    sha256 cellar: :any,                 x86_64_linux:  "acf3582b3e0e31961c36c2df2742a3e6b7215012c94636b8bd0fe389c5eb49d9"
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
