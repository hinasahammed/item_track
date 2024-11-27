import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StockCard extends StatelessWidget {
  const StockCard({super.key, required this.imageUrl, required this.title, this.onTap,});
  final String imageUrl;
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(imageUrl),
              ),
              const Gap(10),
              Text(
                title,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
