class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.696.20.tar.gz"
  sha256 "7f20e73e1275049a9b6a5b474ab5377648b23831b9ae73e5facf3282a1630970"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97e677f0a2de31193430ce685a866d61857e7e7264198fc74ba95644dca61264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc030aff9a5efd018455dc378fdbcbb6068404c6782738c5792d22af5f59bfa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb3818ba7f516aaf35aade67f916d4fcc802e96c671a00d39a0afdd0c0d9605"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fcee86d98fa6c6dcd09f4a21203c57d0a1096840f219535e90e92694d5924b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caf2aaf72cd1e96c4bbd57450fad4f4f8eeec9fcf7f1cf6fd8785c90a2e6bef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf8fed03e372d005abe1540865ba11ddd57b6e1887fce9d75e6f1c06b232b27"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
