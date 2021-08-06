import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class BlurHashImageScreen extends StatelessWidget {
  const BlurHashImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * (0.5),
            height: MediaQuery.of(context).size.height * (0.25),
            child: OctoImage(
              image: CachedNetworkImageProvider('https://blurha.sh/assets/images/img1.jpg'),
              placeholderBuilder: OctoPlaceholder.blurHash('LEHV6nWB2yk8pyo0adR*.7kCMdnj', fit: BoxFit.cover),
              errorBuilder: OctoError.icon(color: Colors.red),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
