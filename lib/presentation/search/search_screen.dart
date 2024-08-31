import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/presentation/profile/profile_screen.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        toolbarHeight: 80,
        leading: IconButton(
            onPressed: () {
              setState(() {
                if (isShowUser == true) {
                  isShowUser = false;
                }
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => MobileScreenLayout()));
              });
            },
            icon: Icon(Icons.arrow_back)),
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: "Search for a user",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)))),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
          onTapOutside: (value) => FocusScope.of(context).unfocus(),
        ),
      ),
      body: isShowUser == true
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("username", isEqualTo: _searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ProfileScreen(
                                uid: snapshot.data!.docs[index]["uid"])));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]["photoUrl"]),
                        ),
                        title: Text(snapshot.data!.docs[index]["username"]),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SingleChildScrollView(
                  child: StaggeredGrid.extent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(
                      snapshot.data!.docs.length,
                      (index) {
                        return StaggeredGridTile.count(
                          crossAxisCellCount: (index % 7 == 0) ? 2 : 1,
                          mainAxisCellCount: (index % 7 == 0) ? 2 : 1,
                          child: Image.network(
                            snapshot.data!.docs[index]["postUrl"],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
    );
  }
}
