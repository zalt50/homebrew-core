class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://docs.gptscript.ai/"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "fbc17e9274a4185a01449b9fbfcfbf026a50313fa41678919c655943f414d43c"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f147b2ce9e1035a25dcbe301ecbe2c5891c5ba541eef2f652b1d6b6cfb688ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f147b2ce9e1035a25dcbe301ecbe2c5891c5ba541eef2f652b1d6b6cfb688ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f147b2ce9e1035a25dcbe301ecbe2c5891c5ba541eef2f652b1d6b6cfb688ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b81d404e60836e358afb6e2fb32f09544f9f00862450c32a5b145bf1c4a0376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "729500ad1b7263a85d289b11fc08a7cdcac9a973d77204c305344adc30e719b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687f4b607f1800fd154839d8e37a399f4c4b88fda9fe7375a10f9a533f596309"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin/"gptscript", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output("#{bin}/gptscript -v")

    output = shell_output("#{bin}/gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
