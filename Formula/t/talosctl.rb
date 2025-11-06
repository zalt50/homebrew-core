class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "6e9610edce860af0131cbcde9b688e7d10a67a7784d8be8a39e6c5540285f2c2"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b41fa968c44683311e17ad954e2e330d9153ff2dd88d8b3a1083d0637eb8659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65d3f38508a444e5a38ccb10a61cef50033ab9b9801ad39f6625afec5c030753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed51298522488d6f374a357e18d8df963cb5624c7bca2b9bdf35f816bee1f0e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bfe735ea85c2d132d9ab0d5aeeae154ccb5748714f0fbcf65e07a29340d472f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6d3a830b52bd3f5aa6ff3d4197cde67ac253f1a38cd594957363c4fb88169b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b38d3720d7db703aa790c57ed7d289a776a0a39ac493377f75a67a37177643c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
