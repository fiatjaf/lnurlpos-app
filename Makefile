all: lnurlpos.tar.gz lnurlpos.apk

lnurlpos.tar.gz: pubspec.yaml $(shell find lib/)
	flutter build linux --release
	cd build/linux/x64/release/ && \
      mv bundle lnurlpos && \
      tar -cvf lnurlpos.tar.gz lnurlpos
	mv build/linux/x64/release/lnurlpos ./lnurlpos.tar.gz

lnurlpos.apk: pubspec.yaml $(shell find lib/)
	flutter build apk --release --build-number 1 --split-debug-info=v1.0.0 --build-name=1.0.0
	mv build/app/outputs/flutter-apk/app-release.apk ./lnurlpos.apk
