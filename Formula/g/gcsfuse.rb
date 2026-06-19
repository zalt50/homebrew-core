class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "ad01b334ed67fe3c2e36074140e893f9b0b2e247d54ff3b7c8f520f11fb4b785"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c23af53f5181a5520b885a4c85f211965854155dc0e8672112ecdaf08efe5fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7d4f82127695cd81a053d393ce3724d7ca9552ff8b3c72da7989d924f849dfb5"
  end

  depends_on "go" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version.to_s
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system bin/"gcsfuse", "--help"
    system sbin/"mount.gcsfuse", "--help"
  end
end
