class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "9a9e4578b7246ba3051329c7f780ba58208defbb0c157a2b353d889d1057c633"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bdfafe9dd168d157b38b7c508fa6990845112327615b73ab60445a7698d018b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bdfafe9dd168d157b38b7c508fa6990845112327615b73ab60445a7698d018b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bdfafe9dd168d157b38b7c508fa6990845112327615b73ab60445a7698d018b"
    sha256 cellar: :any_skip_relocation, sonoma:        "121f520f3c0110619cb4a6da7607dd6aa4d056f7c590477ec0c51a6ba549e380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66ea0d6fd8733e464327915f04cfe1a19c7a4c84c90e2a7a9be74dcd819cc927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c92d23a6095a5054d947ea9e5468825b001f027c4af35946c285ec5707d1bd3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-remote-gittuf"), "./internal/git-remote-gittuf"

    generate_completions_from_executable(bin/"gittuf", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init"

    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match(
      /Error: (required flag "signing-key" not set|signing key not specified in Git configuration)/,
      output,
    )

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error:", output
    assert_match(/(unable to identify git directory for repository|No such remote 'origin')/, output)

    output = shell_output("#{bin}/git-remote-gittuf 2>&1", 1)
    assert_match "usage: #{bin}/git-remote-gittuf <remote-name> <url>", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
