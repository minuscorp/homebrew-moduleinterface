class Moduleinterface < Formula
    desc "Swift tool to generate Module Interfaces for Swift projects"
    homepage "https://github.com/minuscorp/ModuleInterface"
    url "https://github.com/minuscorp/ModuleInterface/archive/v0.0.4.tar.gz"
    sha256 "f670e857c0ddfa76e7b56dd8d7a1de92ee6587e5e2971febc07ba53d2a07a82e"
  
    depends_on :xcode => ["11.2", :build, :test]
  
    def install
      system "swift", "build", "--disable-sandbox", "-c", "release"
      bin.install ".build/release/moduleinterface"
    end
  
    test do
      assert_match "ModuleInterface v#{version}", shell_output("#{bin}/moduleinterface version")
      # There are some issues with SourceKitten running in sandbox mode in Mojave
      # The following test has been disabled on Mojave until that issue is resolved
      # - https://github.com/Homebrew/homebrew/pull/50211
      # - https://github.com/Homebrew/homebrew-core/pull/32548
      if MacOS.version < "10.14"
        mkdir "foo" do
          system "swift", "package", "init"
          system "swift", "build", "--disable-sandbox"
          system "#{bin}/moduleinterface", "generate",
                 "--spm-module", "foo",
                 "--output-folder", testpath/"Documentation"
          assert_predicate testpath/"Documentation/foo.swift", :exist?
        end
      end
    end
  end
  