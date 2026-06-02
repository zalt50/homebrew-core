class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "7eee1ab479a6588991cfc1be6b8c48010ca3efedbd3fd0902f83537977446c9c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b00743314ad222edda4e1190f7e7c0d75217d470a69de639120488abfaadb47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b00743314ad222edda4e1190f7e7c0d75217d470a69de639120488abfaadb47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b00743314ad222edda4e1190f7e7c0d75217d470a69de639120488abfaadb47"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a144c631abee9acf97dbffa11d8445c6e1857500aa54eaf1421eadc9b317bfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8a5b784a02a5bac60ddfe5b0dd419e7065a79ba4b8213d302be2086ef07b543"
    sha256 cellar: :any,                 x86_64_linux:  "e9c4bf7809717c8e50bea08ba624dd0970f2069e44a1b3ef443977dbbb2d6681"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
