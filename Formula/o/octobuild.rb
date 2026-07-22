class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.9.1.tar.gz"
  sha256 "73e92477f02d02cd9b739e17895824f0ec42d7442163a0395d3bf0cc016c9033"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "327faab1ed7a77c2af1abecdd10bbca5519f26b1d69ffb11323b7ae71fca29bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "746746cd071b800c6ab2c5de1e845aea3eb12707bf4b1e1c7a43f9cff843c895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37de07ee81d246e7dcd2205e54a40d95c066fedebbfa935fe57396b93bbbc826"
    sha256 cellar: :any_skip_relocation, sonoma:        "db11e3f1a190942b949333c52d2379738a23e40acffadb49b77e7e9f78e6e021"
    sha256 cellar: :any,                 arm64_linux:   "d58d10d2b9e3934843ef2d673e98c0ff232cd72dfbffec06e0bbf86ddf050230"
    sha256 cellar: :any,                 x86_64_linux:  "3d9bd572745c7bb2382a2c3dfbf10ca3959f49a03692b25ebc4f1a9d294040fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  resource "ipc-rs" do
    on_linux do
      on_arm do
        url "https://github.com/octobuild/ipc-rs/archive/e8d76ee36146d4548d18ba8480bf5b5a2f116eac.tar.gz"
        sha256 "aaa5418086f55df5bea924848671df365e85aa57102abd0751366e1237abcff5"

        # Apply commit from open PR
        patch do
          url "https://github.com/octobuild/ipc-rs/commit/1eabde12d785ceda197588490abeb15615a00dad.patch?full_index=1"
          sha256 "521d8161be9695480f5b578034166c8e7e15b078733d3571cd5db2a00951cdd8"
          type :unofficial
          resolves "https://github.com/octobuild/ipc-rs/pull/12"
        end
      end
    end
  end

  def install
    if OS.linux? && Hardware::CPU.arm?
      (buildpath/"ipc-rs").install resource("ipc-rs")
      (buildpath/"Cargo.toml").append_lines <<~TOML
        [patch."https://github.com/octobuild/ipc-rs"]
        ipc = { path = "./ipc-rs" }
      TOML
    end
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
