import 'package:bindu_decor/Nav_Widgets/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _blogShow()
        ],
      ),
    );
  }
}

Widget _blogShow() {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: LuxuryTheme.primaryAccent,
      child: Image.asset("assets/images/bindu.png"),
    ),
    title: Text("Blog Title", style: GoogleFonts.aleo(fontSize: 15, fontWeight: FontWeight.bold)),
    subtitle: Row(
      children: [
        Text("Subject", style: GoogleFonts.aleo(fontSize: 13.5, fontWeight: FontWeight.w500)),
        SizedBox(width: 8), SizedBox(
          child: VerticalDivider(
            color: Colors.black87, thickness: 1
          ),
        ),  SizedBox(width: 8),
        Text("Author Name", style: GoogleFonts.aleo(fontSize: 13.5, fontWeight: FontWeight.bold))
      ],
    ),
    trailing: Icon(Icons.chevron_right_rounded, size: 25, color: Colors.black87,),
  );
}