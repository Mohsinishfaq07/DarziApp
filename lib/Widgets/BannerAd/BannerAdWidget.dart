import 'dart:async'; // For Completer

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  // Future to load the banner ad
  Future<BannerAd> _loadBannerAd() async {
    final completer =
        Completer<BannerAd>(); // Completer to handle async operation
    late BannerAd bannerAd; // Declare the BannerAd variable
    bannerAd = BannerAd(
      adUnitId:
          "ca-app-pub-3940256099942544/6300978111", // Your actual ad unit ID here
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          completer.complete(
            bannerAd,
          ); // Completes the future when ad is loaded
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          completer.completeError(
            'Failed to load banner ad: $err',
          ); // Error handling
        },
      ),
    );

    // Start loading the ad
    bannerAd.load();
    return completer.future; // Return the future
  }

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to asynchronously load and display the ad
    return FutureBuilder<BannerAd>(
      future: _loadBannerAd(), // Future that loads the ad
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bannerAd = snapshot.data!;
          return SizedBox(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd), // Display the ad
          );
        } else {
          return const SizedBox(); // Return empty container if no ad data
        }
      },
    );
  }
}
