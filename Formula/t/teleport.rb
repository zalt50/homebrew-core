class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  # Check https://goteleport.com/download/ for valid versions as some git tags
  # aren't marked as GitHub releases but they correspond to official release
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.11.1.tar.gz"
  sha256 "a95bddd445dc3f93d91493b48e73d39959bbc4d4d00cd93fea34b3d02c3ba1da"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # Teleport first does a commercial release and then has a delayed open-source
  # git tag. Not all tags are marked as GitHub releases so we check that the
  # tag has a corresponding official release version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      data = JSON.parse(Homebrew::Livecheck::Strategy.page_content("https://rlz.teleport.sh/versions")[:content])
      released_versions = data.fetch("supportedMajors", []).flat_map { |major| data.dig("versions", major) }
      tagged_versions = tags.filter_map { |tag| tag[regex, 1] }
      tagged_versions & released_versions
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d179902fc3daf073e5d2c263dca2b4e059b0d153b3deda0bb81033719b21b363"
    sha256 cellar: :any, arm64_tahoe:       "824eb2ce8626174ac5b5d68185743d5d12479f7b65e0b06c6c64a1ec45b930df"
    sha256 cellar: :any, arm64_sequoia:     "ab68ce1341b9d143f58037ae8fc6fadeaedd8abef59a6e90ccc02bb2cd6ca76c"
    sha256 cellar: :any, arm64_linux:       "ea148eef1212beef1063305a4f5e71f6c65466034198ad927034573bf9097c90"
    sha256 cellar: :any, x86_64_linux:      "698c0f9ef4995295bb77b65f083f8912e7458894c85b8c427dcb1f81d138e5db"
  end

  depends_on "binaryen" => :build
  # TODO: unpin go@1.26 when teleport bumps `charlievieth/strcase` to v0.0.6+
  # ref: https://github.com/gravitational/teleport/pull/6880
  depends_on "go@1.26" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "rust-wasm" => :build
  depends_on "libfido2"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

  resource "wasm-bindgen" do
    url "https://static.crates.io/crates/wasm-bindgen-cli/wasm-bindgen-cli-0.2.122.crate"
    sha256 "c1686f9fe038f84b892c10d3b7489b291eb110537450159eb97e5f846b3045bc"

    livecheck do
      url "https://raw.githubusercontent.com/gravitational/teleport/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
      regex(/name\s*=\s*"wasm-bindgen".*?version\s*=\s*["'](\d+(?:\.\d+)+)["']/im)
    end
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    resource("wasm-bindgen").stage do
      system "cargo", "install", *std_cargo_args(root: buildpath)
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    # Reduce overlinking with OpenSSL
    ENV.append "CGO_LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    # Avoid passing incorrect target-cpu to wasm
    ENV.delete "HOMEBREW_RUSTFLAGS"

    # Build C code in wasm crates with LLVM as the host `CC` (GCC on Linux) cannot target wasm
    ENV["CC_wasm32_unknown_unknown"] = formula_opt_bin("llvm")/"clang"
    ENV["AR_wasm32_unknown_unknown"] = formula_opt_bin("llvm")/"llvm-ar"

    # Workaround for error: The CPU Jitter random number generator must not be compiled with optimizations.
    # Issue ref: https://github.com/aws/aws-lc-rs/issues/1097
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

    # Linux-only `teleport-update` needs Teleport's signing keys; without them it refuses all updates
    ENV["TELEPORT_UPDATE_DEV_BUILD"] = "1" if OS.linux?

    inreplace "Makefile" do |s|
      # Workaround for Homebrew's installation layout as rust cannot find rust-wasm
      s.gsub! %q(RUSTFLAGS='--cfg getrandom_backend="wasm_js"'),
              %Q(RUSTFLAGS='--cfg getrandom_backend="wasm_js" --sysroot #{HOMEBREW_PREFIX} --codegen linker=wasm-ld')

      # avoid building another wasm-opt
      s.gsub!(/^(ensure-wasm-deps: .*) ensure-wasm-opt( .*)?$/, "\\1\\2")
    end

    # TODO: Makefile expects git clone but not possible while private enterprise submodule is referenced:
    # https://github.com/gravitational/teleport/commit/dbf752d73b99639cd9b64cfd9fef047806f61863
    inreplace "integrations/terraform-modules/gen/docs.sh",
              "$(git rev-parse --show-prefix)",
              "integrations/terraform-modules/gen/"

    ENV.deparallelize { system "make", "full", "FIDO2=dynamic", "LLVM_DIR=#{formula_opt_prefix("llvm")}" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~YAML
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    YAML

    spawn bin/"teleport", "start", "--roles=proxy,node,auth", "--config=#{testpath}/config.yml"
    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl status --config=#{testpath}/config.yml")
    assert_match(/Cluster:\s*testhost/, status)
    assert_match(/Version:\s*#{version}/, status)
  end
end
