cask "eyebreak" do
  version "2.4.0"
  sha256 "c89e99758b140d7ad8baa729266866a26d67c595bd5195bbb71686f9fdb70765"

  url "https://github.com/cheat2001/eyebreak/releases/download/v#{version}/EyeBreak-v#{version}.dmg"
  name "EyeBreak"
  desc "Eye care reminder app that helps you take regular breaks"
  homepage "https://eyebreak.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "EyeBreak.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/EyeBreak.app"]
  end

  caveats <<~EOS
    The Gatekeeper quarantine flag is cleared automatically after install
    (EyeBreak is open source but not yet notarized with Apple). If macOS
    still reports the app as damaged, run:

      xattr -cr /Applications/EyeBreak.app

    EyeBreak updates itself from v2.4.0 onwards, so you will not need to
    reinstall it for future versions.
  EOS

  zap trash: [
    "~/Library/Application Support/EyeBreak",
    "~/Library/Caches/com.eyebreak.app",
    "~/Library/Preferences/com.eyebreak.app.plist",
    "~/Library/Saved Application State/com.eyebreak.app.savedState",
  ]
end
