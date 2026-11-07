# A cask that installs Oracle SQL Developer (with bundled JDK) for Apple Silicon.
cask "sqldeveloper" do
  version "26.2.0.186.2220"
  sha256 "914a886e2692affd683176778f3060db46f273cfc278b1988de82f65df3f1f4a"

  url "https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-#{version}-macos-aarch64.app.zip"
  name "Oracle SQL Developer"
  desc "Graphical tool for Oracle Database development"
  homepage "https://www.oracle.com/database/sqldeveloper/"

  depends_on arch: :arm64

  app "SQLDeveloper.app"

  zap trash: "~/.sqldeveloper"
end
