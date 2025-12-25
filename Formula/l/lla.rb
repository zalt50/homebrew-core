class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "070ed3248049b6c657e735552fb2e42a4fe116e1f0dbe230d5a33c9c6f62383e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f130bebb333bf11899d53b6f6a79aa9d07a02665f7cfcf36c5657cd8e25ef0f"
    sha256 cellar: :any,                 arm64_sequoia: "1ec7b484b2a76c7f10ecc07b65936bc86c6cb692c4a8073f4be284f6b8b914ec"
    sha256 cellar: :any,                 arm64_sonoma:  "79f8c5c5290b55fbb1b85d24c8fa5aa1fb1092c95321d78b94eb8fae2cb1a622"
    sha256 cellar: :any,                 sonoma:        "7a4409ef9e8ecc8a918754277dad9a56a7e70fc1831dceacb2dec5d8ab18a12a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e22b8c64d52926fd3b302b054ca709b242fc0024a7f0136f10cf60f226fd29d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46166d55d1a24cfbf378b89fd9b1cab1387dfc45d92117cee20e6d66943f094f"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # fix `editor = null` toml config parsing error, upstream pr ref, https://github.com/chaqchase/lla/pull/148
  patch do
    url "https://github.com/chaqchase/lla/commit/2a5901cd5108759915cd8370669ec130d9b2df34.patch?full_index=1"
    sha256 "cafb622a851c085e616b361fffcba7b2b3e33290f823e406acc0b2dc0f2b0ff5"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    (buildpath/"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin/"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["target/release/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath/".config/lla/config.toml"

    system bin/"lla", "init", "--default"

    output = shell_output("#{bin}/lla config")
    assert_match "Config file: #{test_config}", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
