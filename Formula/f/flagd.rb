class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.14.0",
      revision: "ff28fd70ab30583ef3ecd59ab6b375dc66408f69"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  # The upstream repository contains tags like `core/v1.2.3`,
  # `flagd-proxy/v1.2.3`, etc. but we're only interested in the `flagd/v1.2.3`
  # tags. Upstream only appears to mark the `core/v1.2.3` releases as "latest"
  # and there isn't usually a notable gap between tag and release, so we check
  # the Git tags.
  livecheck do
    url :stable
    regex(%r{^flagd/v?(\d+(?:[.-]\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fb2bd22913fed33ea15563e7649e533b0ecc57ab04415d659f470e133697dd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b149c0fec38ebeffc84f478621dff2805fc2ceae1331ec4f9346d20e624a028c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12d6ce2bdb081f2c03ad42d158697e51f4ccd2ffa22ae3a2f47123a69aab0ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a8e23a498e7827ee0b577584c76c601b20b2200a69c386118cb2a1d75a10c8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f9d29002ec8fe9ca95c02d5dcfc8543deb44a39d1ba154d44c0f14df12c579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcb4dd808e93776e52673c5afaa0666f2353db01f3bfcd88609cb447a959f1d9"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags:), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    json_url = "https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: application/json" \
      localhost:#{port}/schema.v1.Service/ResolveBoolean
    BASH

    pid = spawn bin/"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
