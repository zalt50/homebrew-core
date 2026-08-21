class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.13.0",
      revision: "f838df1edb6265abbfa24f5cbb7381b21c735642"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe8b88a9e8824a18a000b6df4d7792eb1846500b373e683467c6f61eb9f95ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa24bed4fb60eacba0d5ada7497ec1c68e09ba61b21f405c74a35aff2dd85c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3da34c4fa901b5688332ed28dfc1e7d33cd4a273b972acb108a7d043480134"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e869901bc539ee98fa3c6c12603edc1675f65a40c23dc219ad588c1af1ca31f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe93d372c0b9fb868fea03afc0c95925fd9fd3a06928cb8d35ddb0b9d9159bf4"
    sha256 cellar: :any,                 x86_64_linux:  "9abcd91fbc52586e7403a736cf9a13a53bd407a01b4e73136707f21c5fa5aae1"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
