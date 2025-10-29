class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "695655a2e1b73f261cd912b9861fb7f9868de6084117d2862da40e0a0d0e61c1"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35e13e166d5e0a379815a76c7217eb2a522d9f7fe35b1ea6e437a18a90ed86a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18ce8302fb409c413518431c9ef81ad0bd3333f1ad326ca25741a29273aa08a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c37ff3a3923240cf248b11fab797cac9ab63ce4d3011185f2c5c8f851cf5fd8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c2eca319505a652c3c2f0574105aa201c53d164c3214df7fa7b7865208f079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae266459e4b949793b0385d6d41c8d7ea9fa97af90d7175acfa1dac584fd356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cab3a400ad6839d7d7b1f3fba7554dcd2c2fb7d89dbe9a08862ff5bacbcbcb9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end
