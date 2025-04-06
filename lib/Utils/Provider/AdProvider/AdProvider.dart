import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final bannerAdProvider = StateNotifierProvider<BannerAdNotifier, BannerAdState>(
  (ref) {
    return BannerAdNotifier();
  },
);

class BannerAdState {
  final BannerAd? bannerAd;
  final bool isLoaded;

  BannerAdState({this.bannerAd, this.isLoaded = false});

  BannerAdState copyWith({BannerAd? bannerAd, bool? isLoaded}) {
    return BannerAdState(
      bannerAd: bannerAd ?? this.bannerAd,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class BannerAdNotifier extends StateNotifier<BannerAdState> {
  late BannerAd _bannerAd;
  late BannerAd _bannerAd2;

  BannerAdNotifier() : super(BannerAdState()) {
    loadAd();
  }

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId:
          "ca-app-pub-3940256099942544/6300978111", // Replace with your real ad unit ID
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          state = state.copyWith(bannerAd: _bannerAd, isLoaded: true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          state = state.copyWith(isLoaded: false);
        },
      ),
    );
    _bannerAd.load();
  }

  void loadAd2() {
    _bannerAd = BannerAd(
      adUnitId:
          "ca-app-pub-3940256099942544/6300978111", // Replace with your real ad unit ID
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          state = state.copyWith(bannerAd: _bannerAd, isLoaded: true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          state = state.copyWith(isLoaded: false);
        },
      ),
    );
    _bannerAd2.load();
  }

  void disposeAd() {
    _bannerAd.dispose();
    state = state.copyWith(bannerAd: null, isLoaded: false);
  }
}
