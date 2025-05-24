import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNewsCard extends StatelessWidget {
  const ShimmerNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(86, 141, 141, 141),
                blurRadius: 5,
                spreadRadius: 3,
              ),
            ],
          ),
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[350]!,
                  highlightColor: Colors.grey[50]!,
                  child: Container(
                    width: double.infinity,
                    height: 210,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20.0,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 150.0,
                      height: 20.0,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 60.0,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ShimmerAdd extends StatelessWidget {
  const ShimmerAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            //  borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(86, 141, 141, 141),
                blurRadius: 5,
                spreadRadius: 3,
              ),
            ],
          ),
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: SizedBox(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[350]!,
                    highlightColor: Colors.grey[50]!,
                    child: Container(
                      // width: double.infinity,
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //  width: double.infinity,
                        width: 200,
                        height: 8.0,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 150.0,
                        height: 8.0,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
