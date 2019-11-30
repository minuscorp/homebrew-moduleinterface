class Moduleinterface < Formula
    desc "Swift tool to generate Module Interfaces for Swift projects"
    homepage "https://github.com/minuscorp/ModuleInterface"
    url "https://github.com/minuscorp/ModuleInterface/archive/v0.0.3.tar.gz"
    sha256 "1b2ec9bd4fa9443febfc5bb73a9b3cc7f2f149e980fc84378aa8fe640e571510"
  
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
  