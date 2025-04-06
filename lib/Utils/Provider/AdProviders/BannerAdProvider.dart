import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Define the BannerAd provider
final bannerAdProvider = Provider<BannerAd>((ref) {
  final bannerAd = BannerAd(
    adUnitId:
        "ca-app-pub-3940256099942544/6300978111", // Test ad ID, replace with your real ad unit
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        log("BannerAd loaded successfully.");
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        log("BannerAd failed to load: ${error.message}");
        ad.dispose();
      },
    ),
  );

  bannerAd.load();

  // Ensure that the ad is disposed of when no longer needed
  ref.onDispose(() {
    bannerAd.dispose();
  });

  return bannerAd;
});
// Define the BannerAd provider
final bannerAdProvider2 = Provider<BannerAd>((ref) {
  final bannerAd = BannerAd(
    adUnitId:
        "ca-app-pub-3940256099942544/6300978111", // Test ad ID, replace with your real ad unit
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        log("BannerAd loaded successfully.");
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        log("BannerAd failed to load: ${error.message}");
        ad.dispose();
      },
    ),
  );

  bannerAd.load();

  // Ensure that the ad is disposed of when no longer needed
  ref.onDispose(() {
    bannerAd.dispose();
  });

  return bannerAd;
});
