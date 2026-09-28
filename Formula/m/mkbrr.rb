class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "7a66b1d397a57ed34a18939e40e400e19998be956fd7923a56ab9b59ced8ffdb"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b951c7f3ea5298b0b6d1d5d39657142a99a6bda470d9379b552a861fb364ab5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b951c7f3ea5298b0b6d1d5d39657142a99a6bda470d9379b552a861fb364ab5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b951c7f3ea5298b0b6d1d5d39657142a99a6bda470d9379b552a861fb364ab5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b951c7f3ea5298b0b6d1d5d39657142a99a6bda470d9379b552a861fb364ab5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97d5bf91a2f1573a938d95339b9f004f58d60fa28de93c0fc7318555cb25658d"
    sha256 cellar: :any,                 x86_64_linux:      "84901cfb5a5b478179d9df4d64e5cf442cb0669a70acb4f8e45c27562c091436"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
