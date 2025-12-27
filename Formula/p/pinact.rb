class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "f47951a7f1298b0a2565125d4af5abef05089edfe089008953a96a76fa2e7bbe"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a85f1bc4acf0a22e10a89da72092996dc0f377614697efdaf2cb300b3fc22c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a85f1bc4acf0a22e10a89da72092996dc0f377614697efdaf2cb300b3fc22c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a85f1bc4acf0a22e10a89da72092996dc0f377614697efdaf2cb300b3fc22c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae81355fe2ccc24c68845c42afb3611a5a4305b780c7e3b1a99a53e98969908f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b896e27c8f56909d5d95c82dd206b64103a923634be5288bec382481f1f96902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4930c3b53de3fc82dfc06dc455ded70f3f3be26b6eb1a2a128f303db3d0dedc1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
