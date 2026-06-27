class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.16.7.tar.gz"
  sha256 "6c8ec5740c0c56f207e40ca9de149af075f1bf1d2429e81965e73a708874a598"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f400fa8bae30d2b74c2409223d0f08827757afa0cb5b8af840cb4707481c2a44"
    sha256 cellar: :any, arm64_sequoia: "15575e16de1d58660ab9f31a4b3935c5c69da8e12bd718323fac1b9e86f12054"
    sha256 cellar: :any, arm64_sonoma:  "b51dd35b6c127f93b601a56b5e56310734f0bd0bad8dbb6ca88050e890bd34f7"
    sha256 cellar: :any, sonoma:        "3203598a2a2654ba87e007d6704511e8e6ffa63edb23b69677bc55e22dc13a0f"
    sha256 cellar: :any, arm64_linux:   "ec108d02799b3704663f195d7ae5e071b0291ad240ae0f2572619f7e82ec3c3d"
    sha256 cellar: :any, x86_64_linux:  "740bff5df71a54323ddf7bcc0fa5b2b926fe1367a795244dd9dee1f5e93ceada"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
