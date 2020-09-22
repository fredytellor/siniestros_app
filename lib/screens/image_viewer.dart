import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String imageURL;
  final String type;

  ImageViewer(this.imageURL, this.type);
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          widget.type,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PhotoView(
        loadingBuilder: (context, imageChunkEvent) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        imageProvider: NetworkImage(
          widget.imageURL,
        ),
      ),
    );
  }
}
