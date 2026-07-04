class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "afb2056db86f9aee3b98de6f8c01ca81e97f00495fd060e7df69ed91fb66baa2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0fc39f38073d137443f8b8f739d5048b640997e7e58662ffeda375a1ff1a6033"
    sha256 cellar: :any, arm64_sequoia: "9241f17d0aa687def16012f88843a7ddff7d941c1358ed038971b0705ee18c86"
    sha256 cellar: :any, arm64_sonoma:  "7645bf5cdb5e67f93cb51b7867e71b85133ecda5c983f6c864f2e1e95741877b"
    sha256 cellar: :any, sonoma:        "0793e2f6e698b3f640f55a9986b1d522394addc76d06ef31543801d060024f4e"
    sha256 cellar: :any, arm64_linux:   "27fbfa4d2514da0bcc8f8f7450bc1f661115fd1c0742b510009ca5ff1971ce56"
    sha256 cellar: :any, x86_64_linux:  "d26866fc35be752df29258877dc01c9ecc34c8be9f35d62d8dc35f35dea674e2"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

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
