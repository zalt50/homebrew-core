class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "2aca54791810246bcc90380f194c2141392f7596c5f17734a6b20bf85a3d7384"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14a5dea8b364c207621e78bb361aad28a2b14725c703e1dc1ecaa5784d0453ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a5dea8b364c207621e78bb361aad28a2b14725c703e1dc1ecaa5784d0453ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14a5dea8b364c207621e78bb361aad28a2b14725c703e1dc1ecaa5784d0453ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "79b5e2ddd4f7b3338997e3a589d82eca1aacd33af3d49653954622d2549d89e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe4bced023511dd85d9e149e65d74d21c3346127a88a4852c86a71d2d0be72e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c36b567125ce0dda569f8f1852088f3b87935cac510486d24f46c75a965c6a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
