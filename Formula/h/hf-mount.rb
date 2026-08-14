class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "c74136c6f827655e8517c8881b9b03c1c7ab6b6dcc63f6f0ec530dd946fadc60"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "409972a34283842dfecd98e1e0970a548ceccae71112983ec35b66593e7fd9c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac179d9e04a941542fb982c7756e957301d456dd88799329d9f05817f3f17f02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc38cc2d5939f40b39ed53c603411130c15b0b4898a601f091950c2fb3fa18af"
    sha256 cellar: :any_skip_relocation, sonoma:        "72a059483ea6069817b271e25c1d8beefd6170d92f67ff38c321f0b73b86b72d"
    sha256 cellar: :any,                 arm64_linux:   "70e976590ba53f82df8545a7c381147d23bff6ab7d195a43c02423afc34a3033"
    sha256 cellar: :any,                 x86_64_linux:  "60550be07ef8446343cc0b9bd62368d735231e13bdaefe6ee67b4845de0effbe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "openssl@4"
  end

  def install
    # macOS FUSE needs closed-source macFUSE (not allowed in homebrew/core)
    features = ["nfs"]
    bins = ["hf-mount", "hf-mount-nfs"]
    if OS.linux?
      features << "fuse"
      bins << "hf-mount-fuse"
    end

    bins.each do |bin_name|
      system "cargo", "install", "--no-default-features",
             "--bin", bin_name, *std_cargo_args(features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hf-mount --version")

    # Daemon registry commands work offline and exercise the PID-file machinery.
    assert_match "No running daemons", shell_output("#{bin}/hf-mount status 2>&1")
    assert_match "no daemon found",
                 shell_output("#{bin}/hf-mount stop #{testpath}/nothing 2>&1", 1)
  end
end
