class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  stable do
    url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.39.0.tar.gz"
    sha256 "a6c5b2af8387f7e9eb953d5ea66d61a57ecb1c2bef698ef154631092195b84b7"

    # Allow using host-installed toolchains
    patch do
      url "https://github.com/envoyproxy/envoy/commit/be513213e888c443f4e00b1343cc05149f4f92a7.patch?full_index=1"
      sha256 "363bf44a752c44b3532b7ce6ebc541e8a85b528ae7c79a6f7e621c881358a106"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7ca0110c9c1c1fc59b0b5ea50f348c9d51adc91a5a72291e3ff0cb8825f8a65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5de75442a3be6565804b84834fe108500d60e914151843fc99efac3e083038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6079f387f6f56aeb169bf52e72a1abaac9570905ba641d3ac473292074055e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "35cd494f8e267a67481023cff71ed3f248af5323c4ed93627ba2dee9d6605d3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a022ed2c9bb910d3623d4cf38756d82eb42084cf7812aad5aa17f8532c423506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "505878e18779ea5426065598359368f2aca6ce572ef2b79609f8539a3efdd9eb"
  end

  depends_on "bazel@8" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "llvm@18" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on xcode: :build
  end

  def install
    # Drop hickory DNS: its rust SDK pulls in mockall (incompatible with macOS)
    # and references `@llvm_toolchain_llvm` labels that aren't registered when
    # LLVM is injected via `BAZEL_LLVM_PATH`.
    inreplace "source/extensions/extensions_build_config.bzl",
              /^\s*"envoy\.network\.dns_resolver\.hickory":.*\n/, ""

    # Build with brew Bazel rather than Bazelisk downloading it
    rm ".bazelversion"

    # Build with brew CMake, Go, Ninja and Python rather than Bazel downloading them
    # https://github.com/envoyproxy/envoy/blob/main/bazel/README.md#building-with-host-provided-toolchains
    inreplace "WORKSPACE" do |s|
      s.gsub! "envoy_dependency_imports()", "envoy_dependency_imports(use_host_tools = True)"
      s.gsub! "envoy_dependencies_extra()", "envoy_dependencies_extra(use_host_tools = True)"
    end

    # Stage a local toolchain root to match official LLVM layout needed by upstream
    ENV["BAZEL_LLVM_PATH"] = llvm_path = buildpath/"llvm-toolchain"
    ENV["BAZEL_USE_HOST_SYSROOT"] = "True"
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    llvm_path.install_symlink(llvm.opt_prefix.children.select(&:directory?) - [llvm.opt_bin])
    (llvm_path/"bin").install_symlink llvm.opt_bin.children
    # TODO: (llvm_path/"bin").install_symlink formula_opt_bin(llvm.name.sub(/^llvm/, "lld")).children
    (llvm_path/"bin").install_symlink which("libtool") if OS.mac? # rules_foreign_cc expects Apple libtool for AR

    # Bazel cannot run in superenv. Also drop binutils as rules_foreign_cc CMake try-compile
    # can pick GNU ld from PATH and fail to link against Envoy's configured sysroot/toolchain
    env_path = (ENV["PATH"].split(":") - [Superenv.shims_path.to_s, formula_opt_bin("binutils").to_s]).join(":")

    bazel_args = %W[--output_user_root=#{buildpath}/user_root]
    args = %W[
      --noenable_bzlmod
      --@envoy//bazel/foreign_cc:parallel_builds
      --compilation_mode=opt
      --curses=no
      --noincompatible_strict_action_env
      --verbose_failures
      --action_env=CMAKE_POLICY_VERSION_MINIMUM=3.5
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --define=wasm=wamr
      --repository_cache=#{HOMEBREW_CACHE}/envoy-repository-cache
      --jobs=#{ENV.make_jobs}
    ]

    args += if OS.linux?
      [
        "--config=clang-local",
        "--repo_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1",
        "--strategy=BootstrapGNUMake=standalone",
        "--strategy=BootstrapPkgConfig=standalone",
        # lld needs help finding libc++.a and libc++abi.a in a non-standard path
        "--linkopt=-L#{llvm_path}/lib",
        "--host_linkopt=-L#{llvm_path}/lib",
        # TODO: Remove in next release as handled by .bazelrc
        "--copt=-Wno-nullability-completeness",
      ]
    else
      ["--config=macos"]
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git",
           "--github_api_token_env_name=HOMEBREW_GITHUB_API_TOKEN"

    system "bazel", *bazel_args, "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    # Copy the configs directory to the pkgshare directory.
    pkgshare.install "configs"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end
    pid = spawn bin/"envoy", "-c", "envoy.yaml"
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  ensure
    Process.kill("HUP", pid)
  end
end
