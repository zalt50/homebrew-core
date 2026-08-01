class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.16.0.tgz"
  sha256 "346484dd30b73cac01455d5504d4336a04a37da94d543434028e8e263e76267e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79371d0d020c444330a2868a841009051195cf31f08112a6a27b680eb73e2f10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79371d0d020c444330a2868a841009051195cf31f08112a6a27b680eb73e2f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79371d0d020c444330a2868a841009051195cf31f08112a6a27b680eb73e2f10"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cbeb039bca869081cac32ffa36c031828eba6064819858b7220f3e994a9a48f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a1bb82c0af5440a50db93e29771c538f5deddf72490630ce92dd2edbd83d985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91853a7b4c1119ea1891ea59691e4cc26d857051766da6046407d584dc00260c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    mac_bin = "VarlockEnclave.app/Contents/MacOS/varlock-local-encrypt"
    libexec.glob("lib/node_modules/varlock/native-bins/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if OS.linux? && basename != "linux-#{arch}"
      deuniversalize_machos dir/mac_bin if OS.mac? && basename == "darwin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/varlock --version")

    (testpath/".env.schema").write <<~TEXT
      # This is the header, and may contain root decorators
      # @envFlag=APP_ENV
      # @defaultSensitive=false @defaultRequired=false
      # @generateTypes(lang=ts, path=env.d.ts)
      # ---

      # This is a config item comment block and may contain decorators which affect only the item
      # @required @type=enum(dev, test, staging, prod)
      APP_ENV=dev
    TEXT

    assert_match "dev", shell_output("#{bin}/varlock load 2>&1")
  end
end
