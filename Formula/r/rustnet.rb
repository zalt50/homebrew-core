class Rustnet < Formula
  desc "Cross-platform network monitoring terminal UI with deep packet inspection"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "258ea142f3ca04e45c33761eb28868a8d8afc62a3f9556a1d5b312e805905ce5"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  depends_on "rust" => :build

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkgconf" => :build
    depends_on "elfutils"
  end

  # Skip cross-rs-specific lib search paths on native Linux builds.
  # Already merged upstream; will no longer apply on the next release.
  # https://github.com/domcyrus/rustnet/pull/259
  patch do
    url "https://github.com/domcyrus/rustnet/commit/9a5208d95904253dbae19fd548f44a91cafbd34f.patch?full_index=1"
    sha256 "bc677735d7ae9924214df0d4cfc261346eab429bc11f182c09c93fbde474673b"
  end

  def install
    ENV["RUSTNET_ASSET_DIR"] = buildpath/"assets-generated"
    (buildpath/"assets-generated").mkpath

    if OS.linux?
      # Homebrew's compiler shim rewrites `clang` invocations to `gcc`, which
      # breaks libbpf-cargo's BPF compile step (it runs `clang -target bpf`,
      # an option gcc rejects). Surface the real clang from llvm in a shim
      # dir that we place first on PATH; regular C compiles still go through
      # Homebrew's gcc as intended.
      (buildpath/"bpf-clang").mkpath
      (buildpath/"bpf-clang"/"clang").make_symlink Formula["llvm"].opt_bin/"clang"
      ENV.prepend_path "PATH", buildpath/"bpf-clang"
    end

    system "cargo", "install", *std_cargo_args

    asset_dir = buildpath/"assets-generated"
    bash_completion.install asset_dir/"rustnet.bash" => "rustnet"
    zsh_completion.install asset_dir/"_rustnet"
    fish_completion.install asset_dir/"rustnet.fish"
    man1.install asset_dir/"rustnet.1"
  end

  test do
    assert_match "rustnet #{version}", shell_output("#{bin}/rustnet --version")
    assert_match "network monitoring", shell_output("#{bin}/rustnet --help").downcase

    output = shell_output("#{bin}/rustnet --log-level not-a-level 2>&1", 1)
    assert_match "Invalid log level", output
  end
end
