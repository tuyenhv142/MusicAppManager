import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_dashboard/views/pages/overview/widgets/info_card.dart';

class OverviewCardsLargeScreen extends StatelessWidget {
  const OverviewCardsLargeScreen({Key? key});

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

                    return Row(
                      children: [
                        InfoCard(
                          title: "Total Tracks",
                          value: totalTracks.toString(),
                          onTap: () {},
                          topColor: Colors.orange,
                        ),
                        SizedBox(
                          width: width / 64,
                        ),
                        InfoCard(
                          title: "Total Artists",
                          value: totalArtists.toString(),
                          topColor: Colors.lightGreen,
                          onTap: () {},
                        ),
                        SizedBox(
                          width: width / 64,
                        ),
                        InfoCard(
                          title: "Total Playlist",
                          value: totalPlaylists.toString(),
                          topColor: Colors.redAccent,
                          onTap: () {},
                        ),
                        SizedBox(
                          width: width / 64,
                        ),
                        InfoCard(
                          title: "Total User",
                          value: totalUsers.toString(),
                          onTap: () {},
                        ),
                      ],
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
