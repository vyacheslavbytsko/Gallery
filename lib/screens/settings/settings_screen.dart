import 'package:flutter/material.dart';

import '../home/home_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          slivers: [
            const HomeAppBar(title: "Settings"),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text("Albums on device", style: Theme.of(context).textTheme.labelLarge, maxLines: 1, softWrap: false,),
                    ),
                  ]
              ),
            ),
          ]
      ),
    );
  }
}