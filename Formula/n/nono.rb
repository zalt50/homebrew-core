class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "214d7aa9756219e6e5ca2e5db2ce9e6754ebc74c4773cc91efc95975283f8e4e"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1efd57c114832afb237522a34f7925a1d9dfba2440447172afd5b4515ac721f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d5609a59b4e508ed1002d0053d0d152664fa1e3d9cc836bbc2d931065c7e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d74774273c1905306c5d111ae1438cb5ca29d9853cd438c2bad57ed3fb2e96c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "47e8e46dbbd54ee3811ea192ea06db69263ca4e704e08b93d4e0df07e36a39d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5fb76c930a3018f084a2e8ba415386ec2254bded0429f9a7d9f2f2ea6ef8184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c05eadb213339f1f0311386c07ee50b9449c6cc34eaf7371efb7fb6200bafad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
