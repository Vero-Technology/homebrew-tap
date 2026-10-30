# Note: if you are viewing this from the tap repo, this file is automatically
# updated from:
# https://github.com/Vero-Technology/abloh-ide/blob/main/ci/abloh-homebrew-macos.rb.template
# by automation in the abloh-ide repo.
# vim:ft=ruby:
cask "abloh" do
  version "20261030-094907-3b9e9ff3"
  sha256 "646f246e458af0917344b14e5bf44b76dfdcefee2d710d4c5aae09ad26826d9d"

  url "https://github.com/Vero-Technology/abloh-releases/releases/download/#{version}/abloh-macos-#{version}.zip"
  name "abloh"
  desc "A multiplayer terminal IDE built on WezTerm"
  homepage "https://abloh.dev/"

  # Unclear what the minimal OS version is
  # depends_on macos: ">= :sierra"

  app "abloh.app"
  [
    "abloh",
    "abloh-gui",
    "abloh-mux",
    "strip-ansi-escapes"
  ].each do |tool|
    binary "#{appdir}/abloh.app/Contents/MacOS/#{tool}"
  end

  preflight do
    # Move "abloh-macos-#{version}/abloh.app" out of the subfolder
    staged_subfolder = staged_path.glob(["abloh-*"]).first
    if staged_subfolder
      FileUtils.mv(staged_subfolder/"abloh.app", staged_path)
      FileUtils.rm_rf(staged_subfolder)
    end
  end

  zap trash: [
    "~/Library/Saved Application State/dev.abloh.ide.savedState",
  ]

  def caveats; <<~EOS
    Cask #{token} related executables like 'abloh', 'abloh-gui',
    'abloh-mux', are linked into
      /usr/local/bin/    for x86 Mac,
      /opt/homebrew/bin/ for M1 Mac.

    Removal of them is ensured by 'brew uninstall --cask #{token}'.
  EOS
  end
end
