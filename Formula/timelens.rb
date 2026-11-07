class Timelens < Formula
  desc "Mac time tracker that labels each minute of your screen with a decision model"
  homepage "https://github.com/scandolo/timelens"
  url "https://github.com/scandolo/timelens.git",
      tag:      "v0.2.0",
      revision: "6ee98b6926744cbb3919725b0749f7339f64dd64"
  license "MIT"

  depends_on "uv"
  depends_on :macos

  # timelens.app: a tiny launcher signed with a Developer ID, so Privacy settings show "timelens"
  # (built from launcher/ in the repo by launcher/build.sh)
  resource "launcher" do
    url "https://github.com/scandolo/timelens/releases/download/v0.2.0/timelens-launcher.zip"
    sha256 "bcf10db4dad6a37c7e188403a76da538abfe5da49839e56c82efd307d61832eb"
  end

  def install
    libexec.install Dir["*"]
    resource("launcher").stage { (libexec/"timelens.app").install "Contents" }
    # TIMELENS_HOME points launchd at the stable opt/ path, so upgrades don't break the background jobs
    (bin/"timelens").write_env_script libexec/"bin/timelens", TIMELENS_HOME: opt_libexec
  end

  def caveats
    <<~EOS
      Run `timelens setup` to pick what to track, connect a model and start.
      Your setup and data live in ~/Library/Application Support/timelens.
    EOS
  end

  test do
    assert_path_exists libexec/"timelens.app/Contents/MacOS/timelens"
    assert_match "timelens setup", shell_output("#{bin}/timelens help")
  end
end
