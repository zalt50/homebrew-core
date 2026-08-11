class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.14.2/kata_0.14.2_source.tar.gz"
  sha256 "d85107793192147cc069e1bb5213a852ad0892fc3387127d073e46c6967b3592"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dddc58466b35dab13cfc74d3e178467ee994ba4a3ec4a5e4057bab23f2b5238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dddc58466b35dab13cfc74d3e178467ee994ba4a3ec4a5e4057bab23f2b5238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dddc58466b35dab13cfc74d3e178467ee994ba4a3ec4a5e4057bab23f2b5238"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd761c425a511e035c06c3cd94a13b4a21546010f0f1e03c5b11accd888381f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f291ee8113f48661d9e4b0e0aab2d7f7177e309f311710393dc8a47c230d5242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b1fc5fdd08fce1c2d67223a345fee2605212216f6d8e7d7680cc4558274eae"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X go.kenn.io/kata/internal/version.Version=v#{version}
      -X go.kenn.io/kata/internal/version.Distribution=homebrew
      -X go.kenn.io/kata/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "-mod=vendor", "-buildvcs=false", "./cmd/kata"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kata version")

    ENV["KATA_HOME"] = testpath/"kata-home"
    ENV["KATA_TELEMETRY_ENABLED"] = "0"
    begin
      system bin/"kata", "init", "--project", "homebrew-test"
      system bin/"kata", "create", "Homebrew test issue"
      assert_match "Homebrew test issue", shell_output("#{bin}/kata list")
    ensure
      system bin/"kata", "daemon", "stop"
    end
  end
end
