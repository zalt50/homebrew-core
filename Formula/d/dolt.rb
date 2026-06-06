class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "b356237e92ff546e252356fc898682df6baf2e01366d195783e656e78930c4de"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc629b4c5fdfd9e94328c50de4aecc124f8158daac35c443f8c3d5cfb833698a"
    sha256 cellar: :any, arm64_sequoia: "078d37d203b6179ba364bd4170983244f707878c95cd92d8f7c18399fbb0fb5e"
    sha256 cellar: :any, arm64_sonoma:  "3ea096478a587877d629d12cce3032991f6e045fb6ca49bbffc48bcb4620bb79"
    sha256 cellar: :any, sonoma:        "685438755498770fa5f6b1b4a48c0c9e9325ca4ec5f5a4469f9aeb8c96b4e5fa"
    sha256 cellar: :any, arm64_linux:   "22cb4abf024103249cc7bdfc6d43b2b417416517a26417ecabe5212fb85fbb7e"
    sha256 cellar: :any, x86_64_linux:  "dae0dad3fe3aa879c0d911dccdb074a895d5e743d431c87d2a840e1cab10864b"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
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
