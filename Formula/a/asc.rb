class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.36.2.tar.gz"
  sha256 "878eaaa6729e436127d769a754bf0fcc8cedffdc2b292721b953036c0ae6cc9a"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789848f1e58a61a9905807d9c92684443195e9bfa9b6bdac3a4e65a73ea0843b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c05ccf6ab11eb1a07ea77e89e533a032d7f06482e3ecca9cc7bf0b5b61c6e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9476ddac315cebfc1ceecd75c31950b7f7794b6892b8c41681b1d0fb7a0fe071"
    sha256 cellar: :any_skip_relocation, sonoma:        "595d908bd5af1a23511fb78b1aab307e733c4343716b0cce263a46398f8dfbb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a6d888e4b986c491fcc4e875ae4af3107c7d61005685eda902c2a9b9045370c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184d48f08369c96ca243a4b2df2adb53c455eae3f5b95cdd9cf5ee6251ef4e4a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
