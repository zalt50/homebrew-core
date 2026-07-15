class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "4825bcbf6d4b62fcce5285a8f95bc60043583fac8a2e048e22f1e82d299ee37a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47593d08b7154abf8c96d956028a1bee80f9b0794f9c61e6ab6a347ab35642c2"
    sha256 cellar: :any, arm64_sequoia: "f361ee33812470d64542e96cb79b81abab52b717e6e4504e49ea744f80c54d68"
    sha256 cellar: :any, arm64_sonoma:  "307adb34bc044f738d66a59412500a0c26965d7bc06589e97ba21167327d57e0"
    sha256 cellar: :any, sonoma:        "fd15ad7422213ccfd1c8cbbf74650d6ee400906e0e505885ace7f811b1ca390d"
    sha256 cellar: :any, arm64_linux:   "7babfe7c8fb38138d203625abf8409b502051d1c3a848aa88eeaa63ab6c31a1a"
    sha256 cellar: :any, x86_64_linux:  "d00b32077e099a414358c5e45dd40c6176eff3428b2b38fe64a3ae67c2d495e6"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
