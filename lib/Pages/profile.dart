import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yarisma_app/Entities/userData.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;

const int maxFailedLoadAttempts = 3;

class Profile extends StatefulWidget {
  Profile({
    required this.userData,
  });
  final UserData userData;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextStyle _textStyle = AppFont().getAppFont();

  RewardedAd? _rewardedAd;

  int _numRewardedLoadAttempts = 0;

  void initState() {
    super.initState();
    _createRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-8337349993896228/5600684268",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      BotToast.showText(text: "Reklam yüklenmedi. Tekrar deneyiniz.");
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        BotToast.showText(text: "Hata");
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(globals.userCollectionID)
          .update({
        'tickets': widget.userData.tickets + 1,
      }).then((value) {
        print("User Updated");
        BotToast.showText(text: "Tebrikler! Bilet Kazandın!");
      }).catchError((error) {
        print("Failed to update user: $error");
      });
    });
    _rewardedAd = null;
  }

  void _showMultiRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      BotToast.showText(text: "Reklam yüklenmedi. Tekrar deneyiniz.");
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        BotToast.showText(text: "Hata");
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      if (widget.userData.ticketAdCounter == 2) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(globals.userCollectionID)
            .update({
          'ticketAdCounter': 0,
        }).then((value) {
          print("User Updated");
        }).catchError((error) {
          print("Failed to update user: $error");
        });
        FirebaseFirestore.instance
            .collection("users")
            .doc(globals.userCollectionID)
            .update({
          'joker': widget.userData.joker + 1,
        }).then((value) {
          print("User Updated");
          BotToast.showText(text: "Tebrikler! Joker kazandınız!");
        }).catchError((error) {
          print("Failed to update user: $error");
        });
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(globals.userCollectionID)
            .update({
              'ticketAdCounter': widget.userData.ticketAdCounter + 1,
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    });
    _rewardedAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 1.0],
                  colors: [
                    Colors.blueAccent.shade400,
                    Colors.blueAccent.shade700,
                  ],
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              duration: Duration(milliseconds: 100),
              height: globals.telefonHeight! * .45,
              width: globals.telefonWidth!,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.userData.tickets.toString(),
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              " giriş biletin var.",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.userData.joker.toString(),
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              " tane 50/50 Joker biletin var.",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.userData.allTrueAnswers.toString(),
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              " kere doğru cevap verdiniz.",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.userData.allWrongAnswers.toString(),
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              " kere yanlış cevap verdiniz.",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "En son yılın ",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.userData.lastWeek!.split("+").first + ".",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              " haftasında quiz çözdünüz.",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Son yapılan quizde ",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.userData.weekScore.toString(),
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              " puan aldınız.",
                              style: _textStyle.apply(
                                fontSizeDelta: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                    onTap: () {
                      _showMultiRewardedAd();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.5, 1.0],
                          colors: [
                            Colors.blueAccent.shade400,
                            Colors.blueAccent.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Joker kazanmak için son " +
                              (3 - widget.userData.ticketAdCounter).toString() +
                              " reklam kaldı. Tıkla!",
                          textAlign: TextAlign.center,
                          style: _textStyle.apply(
                              color: Colors.white, fontSizeDelta: 6),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                    onTap: () {
                      _showRewardedAd();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.5, 1.0],
                          colors: [
                            Colors.blueAccent.shade400,
                            Colors.blueAccent.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Bilet kazanmak için tıkla!",
                          style: _textStyle.apply(
                              color: Colors.white, fontSizeDelta: 6),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
