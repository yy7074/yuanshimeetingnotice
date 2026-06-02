import 'package:flutter/material.dart';

import '../services/apscvir_site_service.dart';

class ApscvirAssetImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final ImageErrorWidgetBuilder? errorBuilder;

  const ApscvirAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final remoteUrl = ApscvirSiteService.remoteAssetUrl(assetPath);
    if (remoteUrl != null) {
      return Image.network(
        remoteUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          errorBuilder: errorBuilder,
        ),
      );
    }
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: errorBuilder,
    );
  }
}
