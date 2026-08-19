import 'package:bindu_decor/Admin_Auth.dart';
import 'package:bindu_decor/Clients.dart';
import 'package:bindu_decor/Gy_aw_mo.dart';
import 'package:bindu_decor/Home_Page.dart';
import 'package:bindu_decor/Proj_Page.dart';
import 'package:bindu_decor/Up_cur_sc.dart';
import 'package:bindu_decor/Wal_Flo_Car.dart';
import 'package:bindu_decor/bl_gl_ar.dart';
import 'package:flutter/material.dart';

import 'About.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bindu Decorators',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.about: (context) => const About(),
        AppRoutes.clients: (context) => const Clients(),
        AppRoutes.wallpapers : (context) => const Wallpapers(),
        AppRoutes.floorings : (context) => const Floorings(),
        AppRoutes.carpets : (context) => const Carpets(),
        AppRoutes.blinds: (context) => const Blinds(),
        AppRoutes.glassfilms: (context) => const GlassFilms(),
        AppRoutes.artificialturfs: (context) => const ArtificialTurfs(),
        AppRoutes.gymfloorings: (context) => const GymFloorings(),
        AppRoutes.awnings: (context) => const Awnings(),
        AppRoutes.mosquitoNets: (context) =>  const MosquitoNets(),
        AppRoutes.upholstery: (context) => const Upholstery(),
        AppRoutes.curtains: (context) => const Curtains(),
        AppRoutes.stretchCeiling: (context) => const StretchCeiling(),
        AppRoutes.projects: (context) => const ProjectsPage(),
        AppRoutes.login: (context) => const AdminAuth()
      },
    );
  }
}