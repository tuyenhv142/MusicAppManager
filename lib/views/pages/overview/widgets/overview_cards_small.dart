import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'info_card_small.dart';

class OverviewCardsSmallScreen extends StatelessWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('track').get(),
      builder: (context, snapshot) {
        int totalTracks = snapshot.hasData ? snapshot.data!.docs.length : 0;

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('user').get(),
          builder: (context, snapshot) {
            int totalUsers = snapshot.hasData ? snapshot.data!.docs.length : 0;

            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('playlist').get(),
              builder: (context, snapshot) {
                int totalPlaylists =
                    snapshot.hasData ? snapshot.data!.docs.length : 0;

                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('singer').get(),
                  builder: (context, snapshot) {
                    int totalArtists =
                        snapshot.hasData ? snapshot.data!.docs.length : 0;

                    return SizedBox(
                      height: 400,
                      child: Column(
                        children: [
                          InfoCardSmall(
                            title: "Total Tracks",
                            value: totalTracks.toString(),
                            onTap: () {},
                            isActive: true,
                          ),
                          SizedBox(
                            height: width / 64,
                          ),
                          InfoCardSmall(
                            title: "Total Artists",
                            value: totalArtists.toString(),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: width / 64,
                          ),
                          InfoCardSmall(
                            title: "Total Playlists",
                            value: totalPlaylists.toString(),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: width / 64,
                          ),
                          InfoCardSmall(
                            title: "Total User",
                            value: totalUsers.toString(),
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
