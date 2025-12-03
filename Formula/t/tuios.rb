class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "7540f754acf80d1be9adcdc1b4db18b5db18086fd979465bfb3032d448c0351a"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cae2e27434e6471d26224bd99f12883c08d397757a93f8cf097bd46cc20b5db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65e4984ad97b393dea02c72b9e0a1baba5c9d87de3866717fe6ca7c2a63da2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "351b2a7aee26c34abe0ce5ef5d3c59c8c40b216e0b91205b868f48eee411692e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbf89b5ab1842ff282ee2a8c6b051303d5e9ac82df6b13755e5401efe576b02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df0a0dac2154040a5436e8c8a1c0ae32fff95cc86cf53a7de8421795c2e3ca2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19c14ad62330c3306c80571e668e398c9ec4847ac0d7541a4dcbde0df9d48b96"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
