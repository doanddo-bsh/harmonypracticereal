source "https://rubygems.org"

# Fastlane 은 Play / TestFlight 업로드 실행기다. GitHub Actions 워크플로에서
# `bundle exec fastlane <lane>` 으로 호출하므로 러너와 로컬이 같은 버전을 쓰도록
# Gemfile.lock 을 커밋한다.
gem "fastlane", "~> 2.230"

# iOS 빌드에 필요하다. Flutter 3.44 에서 대부분의 플러그인이 SPM 으로 넘어갔지만
# Flutter 자체는 여전히 CocoaPod 이라 `pod install` 이 필요하다.
gem "cocoapods", "~> 1.16"
