class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "18df15433bd097e80a9383e6b631ff77fb8a248655435af0cf3da59a15683996"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3874ebabff386a958268a38c9554e68303651a31c46a3e2b33ce338bfbc6bcb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e3f2937c396ea87e8fd2eecdfaa0147325bf12286538017a9e542fe20c5049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "879afd1faee0c42feb6dd4cd24d4c9d1755bd4a353158e37ed7b168d74e0fff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d8a2cb8c0ee2ec869ab7b00c9aff935ac37475c411546f00bfba3fa5db1625e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2472d662ac843698348025470d0ae9a853b85d30e79d17abdfd626e8ad84c85"
    sha256 cellar: :any,                 x86_64_linux:  "dbcf40575e98b4fe624f9d39cb7003cca99aedf01cfbfc9dae0b111247d4f69c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~YAML
      type: FILESYSTEM
      config:
        directory: #{testpath}
    YAML

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
