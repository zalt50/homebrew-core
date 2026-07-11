class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.8.1.tar.gz"
  sha256 "7183fcd0d727c4c0a72a8b6610ef5eca1a3e3a95ceb83e85db8183cad692f247"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96c8f8f2a006376e6962d7e1557e21769d93778272e6277a0b89bb3c1681a15f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b2520dc7f719771deca337daea08467a7ea401cce0c13ecffc9c3d4994e4d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0406d05aaae5df388330092f8d1dcdd5fff7be8fa68c5e5895242a02196f49f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8678a74f8cf030e888d0beb0b8cffaebd0f8983c57b1d5d18319da6b8ecc9e76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf090ad332a96780313a96f254e3bf0c77dfcd5461826e4fb06eb02ea6c85450"
    sha256 cellar: :any,                 x86_64_linux:  "06db7fdb9b8ffa3866011018d9d4d8dbe45b45e04294088b5f05ad4c8d527a15"
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
