class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.76.1.tar.gz"
  sha256 "673e4d9118ac1a40febaa65aa360f0ad4754457864be660f29cd63aa77b3b510"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f720e048b1630fe43747b80eea7c4e853590ee5c216ad6caeb576b27871ff88"
    sha256 cellar: :any,                 arm64_sequoia: "0ad21bf03e0769341fd987436afbcc7d077839b7e2be7a5063879bacc2bdb31f"
    sha256 cellar: :any,                 arm64_sonoma:  "69fffd0a9c1de79ceadfa38012e51e323f654eb55f395687d5fc5f6a11f44eba"
    sha256 cellar: :any,                 sonoma:        "3a007b9069ff32f0ff558bea0e0e574edee74dd8fd9486a644b9d3060a720860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c52a6d8350325328026ca13777196f572a20a13106aacaa29a3e2c5ae3cf931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a60b1fefa51551544150ec0e5540b83b10cd67a8a8de8683492a0f2ca2d6fc3b"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    ENV["CGO_ENABLED"] = "1"

    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
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
