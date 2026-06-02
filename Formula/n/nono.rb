class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "5c6d1898b4992a9c2d24a2d58be82b0539a20ccb265dadf3d9244ab1d6d1982b"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96a2d79d90dfe7471ac5d84e8772cb2b93112616554a3217e8f5a1e0a38b96f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a010e59d0901b89a925a03d68fbe00ed2913b7e8185c5660bc730a5627d0057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef55b4362586b5078a02029e2365abad8b9fdb46cac5c94e4f7d0dec656600c"
    sha256 cellar: :any_skip_relocation, sonoma:        "176cca143197d452fbd57fc2aa4a03ac57eca8cb9f61f8c35ed3d0f4cd3419b7"
    sha256 cellar: :any,                 arm64_linux:   "b2a41e54c56bfa9819d0070188029c811a30eac7f16f4067c6f4ddcef357f7e2"
    sha256 cellar: :any,                 x86_64_linux:  "1262669d96e23213097c2c28cbc9fe82ec40fadc3fe7f69cbe316f85d317d6d8"
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
