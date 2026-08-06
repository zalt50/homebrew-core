class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "6a468e1ba0b0d87653299d7a7e299a300fb8b6841d58c6fd6c6efc0ad95a8546"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0800cffa39a7f52de77302296d17bce397c08d61480839812ea65a79751533c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0275c90258edf9e6f13e575db1a951e6d8d5ec049eb9999bb051be3f043eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "403641539c8eae0bc06fc7a7dec87c36070e703677220b5368d959b219b49a24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043c0eb8d776a4e76a282bc56375cf412dc339e29dd36ff585c4a881655acef5"
    sha256 cellar: :any,                 x86_64_linux:  "5b1c4141386e56b5bd9ecfbea60f0044426ca445280e0becec6590dd5db3f9f8"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    mkdir testpath/"astro-project"
    cd testpath/"astro-project" do
      run_output = shell_output("#{bin}/astro config set -g container.binary podman")
      assert_match "Setting container.binary to podman successfully", run_output
      run_output = shell_output("#{bin}/astro dev init")
      assert_match "Initialized empty Astro project", run_output
      assert_path_exists testpath/".astro/config.yaml"
    end

    run_output = pipe_output("#{bin}/astro login astronomer.io --token-login=test", "test@invalid.io", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
