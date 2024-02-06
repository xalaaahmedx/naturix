import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  File? _file;
  int currentPage = 0;
  int? LastPage;

  @override
  _fetchNewMedia() async {
    LastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: 60, size: currentPage);
      for (var asset in media) {
        if (asset.type == AssetType.image) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file = path[0];
          }
        }
      }
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(FutureBuilder(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: Stack(children: [
                  Positioned.fill(
                      child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  )),
                ]),
              );
            }
            return Container();
          },
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100]!,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        title: Text(
          'New Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'anekMalayalam',
          ),
        ),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Next'),
          ))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          SizedBox(
            height: 375,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisSpacing: 1, crossAxisSpacing: 1),
              itemBuilder: (context, index) {},
            ),
          ),
          Container(
            width: double.infinity,
            height: 48,
            color: Colors.grey[100],
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Recent',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: _mediaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisSpacing: 1, crossAxisSpacing: 1),
            itemBuilder: (context, index) {
              return _mediaList[index];
            },
          ),
        ],
      ))),
    );
  }
}
