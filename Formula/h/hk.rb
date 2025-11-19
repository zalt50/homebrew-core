class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.21.1",
      revision: "a599a1a88286e0e1f8f29794e874c26627134f06"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0cdc8cf57983b1dc26c9ed31de5eaa406cfe85b2be24c99dfde4ac635bb170a9"
    sha256 cellar: :any,                 arm64_sequoia: "b9b8cb5fecb397bab279e1f4ea0bb448b266e0631bf1109ce7b86d58fd08b76e"
    sha256 cellar: :any,                 arm64_sonoma:  "2e0f036f32dd2aa5bbcafa4190f93ca60dd28f5501716ff77bb383582b4c663e"
    sha256 cellar: :any,                 sonoma:        "a4a5440483bf0f12da27b3ed6c2bbd4d7cc264d247e8320400bb45053fb5427d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a85470ab48bf289107f1f8040f2d692121e76273524dd37f54437c07345fe47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217512db03aeec8a4813421bacc51eb052927ea0e8ddfc65eaf5dd7a04829a49"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
