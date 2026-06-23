class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.104.0",
    revision: "adc74f82d7c80b74e6fd363610a20a5414b5f561"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38c26657da4086166a33794fcc053134533e26682b6c1a0917ff8e8ca2761a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c26657da4086166a33794fcc053134533e26682b6c1a0917ff8e8ca2761a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c26657da4086166a33794fcc053134533e26682b6c1a0917ff8e8ca2761a0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e52f98dce6a76ae045198d81a43bd95fb9f6c762318c499a9a5dba373e16579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df75cc2d75a9660d5f647c1d929a11dfdbf6ac66d8bd390b54d73ca9d61ba815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d2a0688a78d430b4a4b9660277342cdd9c886db04a8ee956b7f72010da5c7c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
