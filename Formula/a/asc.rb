class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.4.1.tar.gz"
  sha256 "634bf299812245aec334c43b836f7427d6e0a0ca5c72e22ad3e505fd43594bdd"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc5f25fe6dabe8b31a0dcdfc87463115260e72c2a0c5458f3673e4502dc18025"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f3cfe0b91341682ac7751ed2f57384df3e46ea8dfb712ba99efb2acb2796a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7b9b806590d7abca765a5144c53a4fa894c272fd7900af002222a8710e30b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7db64516a31173b7b1a40910f591c47fcfaf11a0c6e458124d06d9e5c971610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4fa7470395503bc30727d20ec97e8178df61a16cc7978db796b33879a722bf1"
    sha256 cellar: :any,                 x86_64_linux:  "597c0f44e40c1d8dbc87081e8b284085be6f483c46b7f5fa9ac827f233f39fa5"
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
