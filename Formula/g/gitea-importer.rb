class GiteaImporter < Formula
  desc "CLI to migrate repositories from GitHub, GitLab and Gitea into Gitea"
  homepage "https://gitea.com/gitea/importer"
  url "https://gitea.com/gitea/importer/archive/v0.2.0.tar.gz"
  sha256 "dc132301c893d6212cab543053ebbcb94d0cd42652e33869ca52d047b4b3a3ca"
  license "MIT"
  head "https://gitea.com/gitea/importer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "564685f70d2765a08ccaf49bc6b9bcd15b87fd78f2a2287f4de620d516ed80d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "564685f70d2765a08ccaf49bc6b9bcd15b87fd78f2a2287f4de620d516ed80d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "564685f70d2765a08ccaf49bc6b9bcd15b87fd78f2a2287f4de620d516ed80d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7163212ce65f1e8725caa443ec4b04c3a1560041ffcd2f510f4d6d64101bdf6d"
    sha256 cellar: :any,                 x86_64_linux:      "0557a0d9a802203f26b61f0abd3ae46ba0e5c82c64223fdcfebd850cef74acbe"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X gitea.com/gitea/importer/internal/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitea-importer version")

    output = shell_output("#{bin}/gitea-importer scan --source-type gitea --source-repos foo/bar 2>&1", 1)
    assert_match "gitea provider requires a token", output

    url = "http://127.0.0.1:#{free_port}"
    args = %W[--source-type gitea --source-url #{url} --source-auth pat://test --source-repos foo/bar]
    output = shell_output("#{bin}/gitea-importer scan #{args.join(" ")} 2>&1", 1)
    assert_match "Get \"#{url}/api/v1/", output
  end
end
