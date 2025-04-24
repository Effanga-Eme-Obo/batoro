import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import 'documents.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // final List<String> _docs = [
  //   'assets/images/all_files.png',
  //   'assets/images/pdf_files.png',
  //   'assets/images/ppt_files.png',
  //   'assets/images/word_files.png',
  //   'assets/images/excel_files.png',
  //   'assets/images/sheet_files.png',
  //   'assets/images/text_files.png',
  //   'assets/images/zip_files.png',
  //   'assets/images/favourite_files.png',
  // ];
  //
  // final List<Color> _colors = [
  //   BColors.allFiles,
  //   BColors.pdfFiles,
  //   BColors.pptFiles,
  //   BColors.wordFiles,
  //   BColors.excelFiles,
  //   BColors.sheetFiles,
  //   BColors.textFiles,
  //   BColors.zipFiles,
  //   BColors.bookmarkedFiles,
  // ];

  final List<Map<String, dynamic>> _docs = [
    {'icon': Icons.folder, 'label': 'All Files', 'count': 25, 'color': BColors.allFiles},
    {'icon': Icons.picture_as_pdf, 'label': 'PDF Files', 'count': 10, 'color': BColors.pdfFiles},
    {'icon': Icons.slideshow, 'label': 'PPT Files', 'count': 5, 'color': BColors.pptFiles},
    {'icon': Icons.insert_drive_file, 'label': 'Word Files', 'count': 1, 'color': BColors.wordFiles},
    {'icon': Icons.table_chart, 'label': 'Excel Files', 'count': 2, 'color': BColors.excelFiles},
    {'icon': Icons.grid_on, 'label': 'Sheet Files', 'count': 4, 'color': BColors.sheetFiles},
    {'icon': Icons.description, 'label': 'Text Files', 'count': 1, 'color': BColors.textFiles},
    {'icon': Icons.archive, 'label': 'Zip Files', 'count': 2, 'color': BColors.zipFiles},
    {'icon': Icons.bookmark, 'label': 'Bookmark Files', 'count': 25, 'color': BColors.bookmarkedFiles},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BColors.lightGrey,
      appBar: AppBar(
        backgroundColor: BColors.allFiles,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Batoro', style: TextStyle(fontFamily: 'Mistrully', color: Colors.white)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 30, right: 30, bottom: 18),
              child: CupertinoSearchTextField(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 15),
                backgroundColor: Colors.white,
                controller: _searchController,
                placeholder: 'Click Here To Search',
              ),
            ),
            //SizedBox(height: 57),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: BColors.white,
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('Document Files', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8
                        ),
                        itemCount: _docs.length,
                        itemBuilder: (context, index){
                          final doc = _docs[index];
                          return _buildGridButton(
                            icon: doc['icon'],
                            label: doc['label'],
                            count: doc['count'],
                            color: doc['color'],
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocumentPage(
                                    title: doc['label'],
                                    color: doc['color'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required VoidCallback onPressed
  }){
    // return Container(
    //   padding: const EdgeInsets.all(8.0),
    //   // decoration: BoxDecoration(
    //   //   borderRadius: BorderRadius.circular(20),
    //   //   border: Border.all(color: color, width: 2),
    //   //   image: DecorationImage(
    //   //     image: AssetImage(imagePath),
    //   //     fit: BoxFit.contain,
    //   //   ),
    //   // ),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(20),
    //     border: Border.all(color: color, width: 2),
    //     color: Colors.white,
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Container(
    //         padding: EdgeInsets.all(10),
    //         decoration: BoxDecoration(
    //           color: color?.withOpacity(0.1),
    //           shape: BoxShape.circle,
    //         ),
    //         child: Icon(icon, color: color, size: 30),
    //       ),
    //       SizedBox(height: 8),
    //       Text(
    //         label,
    //         style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w600, fontSize: 8),
    //         textAlign: TextAlign.center,
    //       ),
    //       SizedBox(height: 4),
    //       Text(
    //         '$count Files',
    //         style: TextStyle(fontSize: 10, color: Colors.grey),
    //       ),
    //     ],
    //   ),
    // );
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: color, backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: color, width: 2),
        ),
        padding: const EdgeInsets.all(8.0),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$count Files',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
