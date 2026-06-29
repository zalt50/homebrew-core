class VultrCli < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  stable do
    url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.10.0.tar.gz"
    sha256 "cc5caa50168e2dd94600e7cbb7449d1435fa6a656a641be98da483b3de871958"

    # Backport better handling when config file is missing
    patch do
      url "https://github.com/vultr/vultr-cli/commit/6959db75adc8250eb6426f18b1a816a6dc1fd019.patch?full_index=1"
      sha256 "fd94f9ad45d727b7ecf121f60261c3ba0a4dd0b2e4b4d78000a11d6b62e52ac6"
    end
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr-cli", shell_parameter_format: :cobra)

    # TODO: consider deprecating old name and then remove after a couple releases
    bin.install_symlink "vultr-cli" => "vultr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr-cli version")
    assert_match "Custom", shell_output("#{bin}/vultr-cli os list")
    assert_match "-F __start_vultr-cli",
                 shell_output("bash -c \"source #{bash_completion}/vultr-cli && complete -p vultr-cli\"")
  end
end
