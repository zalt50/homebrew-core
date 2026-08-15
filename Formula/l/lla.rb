class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "e2af65a472ef4884f74eb3fd5e0685fadef05fff2fe967f065002592403a9bb7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "194fa8e9aa962c2d80d8949d8fd74ce4bbfe48cee335054e398ef97ebfe08607"
    sha256 cellar: :any, arm64_sequoia: "ac8ec7dd101c11ca50f20a429452976d7eba6615ff58939d2d4b0197a7fb470b"
    sha256 cellar: :any, arm64_sonoma:  "c3dde51d38ef2a9d217292d9a62ebbde936e2c0cfa4d3aa57fdfe86e034b3e08"
    sha256 cellar: :any, sonoma:        "0a2974cfdd46fb066480d12d6a4764ddafd5f4f2c0ce9e6f992af38ab213a9fc"
    sha256 cellar: :any, arm64_linux:   "3b5013c85c07e8cb436af9fd6fe391780b7253ed6b8b8a6641bd30d3e958a6da"
    sha256 cellar: :any, x86_64_linux:  "ffd61492a601fdb11e1955a414d1dc757e39b65d5cb98ffc30718447925d70ba"
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
