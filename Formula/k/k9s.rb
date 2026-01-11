class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.17",
      revision: "68627675207c1b64b593c44829a7f534ba7eacf4"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a28aa85fb34a5761688c230251f94156fed424d3139e5f489565a27c34a5805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3aa4c7c5334779ef2bacfe7f17e18ef025c3c0598c1da7831ea05210de1037f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d11b0a577183ad9803072e37226104469276bc3470c7a965bd4264c95e83a6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d1dab9875d52278fa2700023419e1967cf31ffe7dca041a31cad416cc135a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17ffa9fa3c1fae5ac3f9204223dc5b53d9fac1e7870efb22ba33bc6d9e6613e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833b857410cbe3da3e5dd044f2c4a363df74226ca827f24129e26ecd4d58148a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", shell_parameter_format: :cobra)
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
