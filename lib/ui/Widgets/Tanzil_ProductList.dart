import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TanzilProductList extends StatelessWidget {
  const TanzilProductList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 200.0,
          height: 100.0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: ListTile(
              leading: Container(
                width: 80,
                height: 130,
                color: Colors.grey.shade100,
              ),
              title: Container(
                height: 20,
                color: Colors.grey,
              ),
              subtitle: Container(
                height: 15,
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}