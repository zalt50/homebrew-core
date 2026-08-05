class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.5.1.tar.gz"
  sha256 "c556df19a6090d17f87576ef4d361141c6898ad4c7bab0ebac4e048cc68ece89"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a99485a63ae32d47407b3c72f3590f9165593a13032ebea5c27eec0cb6cf89b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9f2c89aa2fcee362238238cbc3a92e294c80f2908d0da83b7c49c6538e311ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "855aebd1f59e1879adce982ff5688601b11f36f3b5a6594ef9ce2e25e68cff09"
    sha256 cellar: :any_skip_relocation, sonoma:        "09fe32a9e9cfd51d06b77f635632d26320f741ed87bba84b598d6aae5ede1a62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf90517995a7c08a3ff7efec3657655f1ac2edaf3eefd930c524b2e6b18baacd"
    sha256 cellar: :any,                 x86_64_linux:  "d184212771fc6f358b8a156978eb7b00f1113c7e04c51b19d5f1b8a3fa413831"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
