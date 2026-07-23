class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/25/3a/ddb78f32a0814e66b18a099377a106a2dcdce92d86a034d69d65df9b256e/pre_commit-4.6.1.tar.gz"
  sha256 "03e809865c7d178b9979d06c761fcbfe6808fdaded8581a745bb110e52050421"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ae39eb44f94a1f8980715601f0525990ee0d068ca434f2ed2a10e724fd84ad4"
    sha256 cellar: :any,                 arm64_sequoia: "4561bf99cd4621e05513f3aacf5635b1119653a5fe15ffb1a6b510590df0b01f"
    sha256 cellar: :any,                 arm64_sonoma:  "292a509cb887e284b210c73d9c7f9c5970a093e99bb0e4d5bbc3ae3676555b0c"
    sha256 cellar: :any,                 sonoma:        "49efd4f510a3cd2a34d8a1b3c434b338b69aa70b5d3f8f0c237e9e563062793a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a27ff15a419d0133d4ccd91167458a93ce75eb2265171742890f95ccddab97d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb114325919eb9b5e91a34d5a55447dfbfac633d1de630b6f9b1eb8d2d10846a"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/4e/b5/721b8799b04bf9afe054a3899c6cf4e880fcf8563cc71c15610242490a0c/cfgv-3.5.0.tar.gz"
    sha256 "d5b1034354820651caa73ede66a6294d6e95c1b00acc5e9b098e917404669132"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/c0/80/8232b582c4b318b817cf1274ba74976b07b34d35ef439b3eb948f98645a1/filelock-3.32.0.tar.gz"
    sha256 "7be2ad23a14607ccc71808e68fe30848aeace7058ace17852f68e2a68e310402"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/52/63/51723b5f116cc04b061cb6f5a561790abf249d25931d515cd375e063e0f4/identify-2.6.19.tar.gz"
    sha256 "6be5020c38fcb07da56c53733538a3081ea5aa70d36a156f83044bfbf9173842"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/24/bf/d1bda4f6168e0b2e9e5958945e01910052158313224ada5ce1fb2e1113b8/nodeenv-1.10.0.tar.gz"
    sha256 "996c191ad80897d076bdfba80a41994c2b47c68e224c542b48feba42ba00f8bb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/78/9b/560e4be8e26f6fd133a03630a8df0c663b9e8d61b4ade152b72005aec83b/platformdirs-4.11.0.tar.gz"
    sha256 "0555d18370482847566ffabcaa53ad7c6c1c29f195989ae1ed634a05f76ea1e0"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/f1/51/276f964496a5714ab9f320896195639086881c2b39c03b5ad13de84acbb8/python_discovery-1.5.0.tar.gz"
    sha256 "3e014c6327154d3dda27939a9a0dc9c5c000439f1906d3f303b48f984bd2ecef"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/fe/25/e367a7229b0914772ca8d81b41fde012d9feda68523b52644a571bb21ce8/virtualenv-21.7.0.tar.gz"
    sha256 "7f9519b9432ff11b6e1a3e94061664efc2ff99ea21780e3cf4f6bd0a5da8b37c"
  end

  def python3
    "python3.14"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~YAML
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    YAML
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
