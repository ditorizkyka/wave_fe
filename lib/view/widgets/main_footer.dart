import 'package:flutter/material.dart';

class MainFooter extends StatelessWidget {
  const MainFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      color: const Color(0xFF4366DE),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Image.asset(
          "assets/images/logo_white.png",
        ),
      ),
    );
  }
}
