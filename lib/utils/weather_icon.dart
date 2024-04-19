import 'package:flutter/material.dart';

class WeatherIcon extends StatefulWidget {
  final double radius;
  final int? isDay;
  final String icon;
  const WeatherIcon({
    super.key,
    required this.radius,
    required this.isDay,
    required this.icon,
  });

  @override
  State<WeatherIcon> createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  @override
  Widget build(BuildContext context) {
    Color boxColor = const Color.fromARGB(255, 16, 31, 80);
    if (widget.isDay == null) {
      boxColor = Colors.transparent;
    } else if (widget.isDay! > 0) {
      boxColor = Color.fromARGB(255, 240, 240, 240);
    }

    return Container(
      width: widget.radius,
      height: widget.radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(180),
        color: boxColor,
      ),
      child: Center(
        child: Image.network(
          "https:${widget.icon}",
          fit: BoxFit.cover,
          width: widget.radius,
          height: widget.radius,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
