class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "070ed3248049b6c657e735552fb2e42a4fe116e1f0dbe230d5a33c9c6f62383e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49090628388fe9b079a0d142257c9d41faeb202ecc4b48722fc622565185d67b"
    sha256 cellar: :any,                 arm64_sequoia: "a9d18f9e18ea44f28c9e3bd7191af8ffd53838498deef40fa489800d68f09530"
    sha256 cellar: :any,                 arm64_sonoma:  "66e6642528f8a29d679e4a086999a4affb3557e477b3bce809dbd9d7d8b9ec2a"
    sha256 cellar: :any,                 sonoma:        "4973582d5b9a92bf07cafcdfb5a8179dc5b7d72200e8a285adbe917a82eac83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "977f7378d7f8851be28d3e815788e2806455a259c6e781517d545841bb7fee14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc4538a4d9b4a436b2fef781cbf02b2b55753e52bb58a8a174909551ed6620e3"
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
