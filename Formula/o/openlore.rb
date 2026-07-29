class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-2.1.7.tgz"
  sha256 "86e36f8cfd66f3594d2825d31a5954b565312dd5e1210840a74ca6109f8f0c8c"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "ac5da2dd37060fc8fed6cf40a9708f6c68a9346ad0e88eb713b8200ef0780479"
    sha256               arm64_sequoia: "5cffe04e9452df34b76333916e619a392833276adc80f6045bd6ffa18e03667a"
    sha256               arm64_sonoma:  "b0858342eb662de285dcaa583ab06ba899b4907f58f6099a23eff16dc4c6c19d"
    sha256               sonoma:        "f5b331c4373324449da57f9d8873307f567d5cf76f3e60ffbd92cb6a4cf766f1"
    sha256 cellar: :any, arm64_linux:   "c9c02de4a23f6cca48ce86c3fa12ab8f839a0fa6e9fcca0440325df77cdbeac2"
    sha256 cellar: :any, x86_64_linux:  "b3bc0bf3b231b3d9ccb3867d3473582a73ed214ecdb64604b9df4be557ed4fe8"
  end

  depends_on "c-ares"
  depends_on "ca-certificates"
  depends_on "hdrhistogram_c"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "libffi"

  on_linux do
    depends_on "python@3.14" => :build # for `node-gyp`
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/openlore/node_modules"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"

    # Prebuilds are unreliable (x86_64 mislabeled as linux-arm64); rebuild from source
    inreplace node_modules/"tree-sitter/binding.gyp", "c++17", "c++20" # node 26 headers require C++20
    rm_r node_modules.glob("**/prebuilds")
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    cd libexec/"lib/node_modules/openlore" do
      node_modules.glob("{*,*/node_modules/*}/binding.gyp")
                  .each { |gyp| system "npm", "rebuild", gyp.parent.basename.to_s }
    end

    # Keep only the native `onnxruntime-node` binaries
    node_modules.glob("onnxruntime-node/bin/*/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != os }
    node_modules.glob("onnxruntime-node/bin/*/*/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != arch }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openlore --version")
    assert_match "<!-- BEGIN OPENLORE", shell_output("#{bin}/openlore install --dry-run 2>&1")
    assert_match "Node.js version", shell_output("#{bin}/openlore doctor")

    node_modules = libexec/"lib/node_modules/openlore/node_modules"
    system formula_opt_bin("node")/"node", "-e",
           "require('#{node_modules}/tree-sitter'); require('#{node_modules}/onnxruntime-node')"

    (testpath/"test.ts").write("function foo() { bar(); } function bar() {}")
    assert_match "Initialization Complete", shell_output("yes | #{bin}/openlore init")
    assert_match "Ready for generation!", shell_output("#{bin}/openlore analyze")
    # call-graph nodes only appear when the native parser loaded
    assert_match "test.ts::foo", (testpath/".openlore/analysis/llm-context.json").read
  end
end
