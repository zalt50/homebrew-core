class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://editorconfig-checker.github.io/"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "44d630c12d712cd132764582edb45a2e0db1600a47a87307ee747b4195d06278"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "195df7e25c63384b9a194b845242d5f6a2e3e83e6662acf99840aaf560598dea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "195df7e25c63384b9a194b845242d5f6a2e3e83e6662acf99840aaf560598dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "195df7e25c63384b9a194b845242d5f6a2e3e83e6662acf99840aaf560598dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "dda8ab108f63d55004108fe8806b4f9e7408c61d8ea2ba6aced161a099a84ed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e081faa1d185fd3dd5852f08a9a27b500ead5eb7309cdd81c81c1ce4e463ede9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e02bf8198cdca6d86089ef3df4db13862f83cd101526630bf14cf0e3abe07c8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/".editorconfig").write <<~EOS
      [version.txt]
      charset = utf-8
    EOS
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
