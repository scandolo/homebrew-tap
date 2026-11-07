class Timelens < Formula
  desc "Mac time tracker that labels each minute of your screen with a decision model"
  homepage "https://github.com/scandolo/timelens"
  url "https://github.com/scandolo/timelens.git",
      tag:      "v0.1.1",
      revision: "cc55687e9915e467a1509e724ef29e3d3fe20187"
  license "MIT"

  depends_on "uv"
  depends_on :macos

  def install
    libexec.install Dir["*"]
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
    assert_path_exists libexec/"timelens.py"
    assert_match "timelens setup", shell_output("#{bin}/timelens help")
  end
end
