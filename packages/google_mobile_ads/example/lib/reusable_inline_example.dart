// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants.dart';
import 'dart:io' show Platform;

/// This example demonstrates inline ads in a list view, where the ad objects
/// live for the lifetime of this widget.
class ReusableInlineExample extends StatefulWidget {
  @override
  _ReusableInlineExampleState createState() => _ReusableInlineExampleState();
}

class _ReusableInlineExampleState extends State<ReusableInlineExample> {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  AdManagerBannerAd? _adManagerBannerAd;
  bool _adManagerBannerAdIsLoaded = false;

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 40,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          if (index == 3) {
            return ElevatedButton(
              onPressed: () => loadBannerAd(),
              key: ValueKey('load banner ad'),
              child: Text('load banner ad'),
            );
          }
          if (index == 4) {
            return ElevatedButton(
              onPressed: () => disposeBannerAd(),
              key: ValueKey('dispose banner ad'),
              child: Text('dispose banner ad'),
            );
          }

          final BannerAd? bannerAd = _bannerAd;
          if (index == 5 && _bannerAdIsLoaded && bannerAd != null) {
            return Container(
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                child: AdWidget(ad: bannerAd));
          }

          if (index == 8) {
            return ElevatedButton(
              onPressed: () => loadAdManagerBannerAd(),
              key: ValueKey('load ad manager banner ad'),
              child: Text('load ad manager banner ad'),
            );
          }
          if (index == 9) {
            return ElevatedButton(
              onPressed: () => disposeAdManagerBannerAd(),
              key: ValueKey('dispose ad manager banner ad'),
              child: Text('dispose ad manager banner ad'),
            );
          }

          final AdManagerBannerAd? adManagerBannerAd = _adManagerBannerAd;
          if (index == 10 &&
              _adManagerBannerAdIsLoaded &&
              adManagerBannerAd != null) {
            return Container(
                height: adManagerBannerAd.sizes[0].height.toDouble(),
                width: adManagerBannerAd.sizes[0].width.toDouble(),
                child: AdWidget(ad: _adManagerBannerAd!));
          }

          if (index == 13) {
            return ElevatedButton(
              onPressed: () => loadNativeAd(),
              key: ValueKey('load native ad'),
              child: Text('load native ad'),
            );
          }
          if (index == 14) {
            return ElevatedButton(
              onPressed: () => disposeNativeAd(),
              key: ValueKey('dispose native ad'),
              child: Text('dispose native ad'),
            );
          }

          final NativeAd? nativeAd = _nativeAd;
          if (index == 15 && _nativeAdIsLoaded && nativeAd != null) {
            return Container(
                width: 250, height: 350, child: AdWidget(ad: nativeAd));
          }

          return Text(
            Constants.placeholderText,
            style: TextStyle(fontSize: 24),
          );
        },
      ),
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716',
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            setState(() {
              _bannerAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        ),
        request: AdRequest())
      ..load();
  }

  void loadAdManagerBannerAd() {
    _adManagerBannerAd = AdManagerBannerAd(
      adUnitId: '/6499/example/banner',
      request: AdManagerAdRequest(nonPersonalizedAds: true),
      sizes: <AdSize>[AdSize.largeBanner],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$AdManagerBannerAd loaded.');
          setState(() {
            _adManagerBannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$AdManagerBannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$AdManagerBannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$AdManagerBannerAd onAdClosed.'),
      ),
    )..load();
  }

  void loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511',
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _adManagerBannerAd?.dispose();
    _nativeAd?.dispose();
  }

  void disposeNativeAd() {
    _nativeAd?.dispose();
    setState(() {
      _nativeAd = null;
      _nativeAdIsLoaded = false;
    });
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    setState(() {
      _bannerAd = null;
      _bannerAdIsLoaded = false;
    });
  }

  void disposeAdManagerBannerAd() {
    _adManagerBannerAd?.dispose();
    setState(() {
      _adManagerBannerAd = null;
      _adManagerBannerAdIsLoaded = false;
    });
  }
}
