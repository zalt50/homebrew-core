class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "36594715e31689487f68587f913b2be82a85045218e8f903fcdee77bf7f8299d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "609326b47afa4384df01638ccd8ce441a775a698e9414273cd8af5a614158af2"
    sha256 cellar: :any, arm64_sequoia: "ffb7478eb730f4a289d5fc9e9d9d112989aac59681cb8458e9ea1d8b7f3b8a12"
    sha256 cellar: :any, arm64_sonoma:  "c00d653ea78fb434b843a55fac75a019c0fd6d9d28721ee9c490518bc023cb84"
    sha256 cellar: :any, sonoma:        "df1798da8917019ad512462832cc1be7c4a2782c1e2a2809158b949d8d724493"
    sha256 cellar: :any, arm64_linux:   "a2832f2f50bf61bcba98b0266a632f9feaf5f37beb9168ad01b53ab3930b86e2"
    sha256 cellar: :any, x86_64_linux:  "3552750ddd5258b7e0f1147f5f3b7be96709e0e9a8e9a2af7655c492162445de"
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
