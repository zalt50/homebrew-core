class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.79.3.tar.gz"
  sha256 "8c1de5a59ce98df4ef41c5f1c6d93ec1485b42e44c38186795e6bc1ab215d5d3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c19cd076466399fb930f2a49fe48cad12c87643a66708c31dc3a3ea0f4dfe3d"
    sha256 cellar: :any,                 arm64_sequoia: "8d5838cf7a97e10ac2043d973f872ab20dee1864b422021b4100acf3378c8b01"
    sha256 cellar: :any,                 arm64_sonoma:  "3241903b66c325ab3b077b647eac83a6e56c15e8fb3d672c5d9650b6cbffe8d9"
    sha256 cellar: :any,                 sonoma:        "897d5a54469e1517f347b5fd9b3a56634c422c7b88a0823cc7e1f721a984652c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed552469bc457b709a92789e4ca193d8826ae050e9a6bdda3f8fc3ea71769d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc9894de79071d4761987b0dd68c40809395c7f7de925e0ff3820108392e483"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
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
