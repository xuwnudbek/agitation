import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({super.key, required this.path});
  String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: path.contains("assets/images")
                ? Image.asset(
                    path,
                    fit: BoxFit.contain,
                  )
                : Image.network(
                    path,
                    fit: BoxFit.contain,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CPIndicator(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
