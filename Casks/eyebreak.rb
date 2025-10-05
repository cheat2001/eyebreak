cask "eyebreak" do
  version "1.0.0"
  sha256 :no_check  # Will be updated with actual SHA256 after first release

  url "https://github.com/YOUR_USERNAME/lookaway/releases/download/v#{version}/EyeBreak.zip"
  name "EyeBreak"
  desc "Eye care reminder app that helps you take regular breaks"
  homepage "https://github.com/YOUR_USERNAME/lookaway"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "EyeBreak.app"

  zap trash: [
    "~/Library/Preferences/com.eyebreak.app.plist",
    "~/Library/Application Support/EyeBreak",
  ]
end
