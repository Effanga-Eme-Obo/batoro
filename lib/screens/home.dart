import 'dart:io';

import 'package:batoro/utils/constants/file_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/constants/colors.dart';
import 'documents.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<File> scannedFiles = [];

  @override
  void initState() {
    super.initState();
    _requestAndScanFiles();
  }

  Future<void> _requestAndScanFiles() async {
    final permissionStatus = await Permission.manageExternalStorage.request();

    if (permissionStatus.isGranted) {
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        List<File> files = await scanFilesWithExtensions(
          directory: directory,
          extensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'zip'],
        );
        setState(() {
          scannedFiles = files;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied.")),
      );
      if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  List<Map<String, dynamic>> _generateDocStats() {
    Map<String, int> extensionCounts = {
      'pdf': 0,
      'ppt': 0,
      'pptx': 0,
      'doc': 0,
      'docx': 0,
      'xls': 0,
      'xlsx': 0,
      'txt': 0,
      'zip': 0,
    };

    for (var file in scannedFiles) {
      String ext = file.path.split('.').last.toLowerCase();
      if (extensionCounts.containsKey(ext)) {
        extensionCounts[ext] = extensionCounts[ext]! + 1;
      }
    }

    return [
      {
        'icon': Icons.folder,
        'label': 'All Files',
        'count': scannedFiles.length,
        'color': BColors.allFiles
      },
      {
        'icon': Icons.picture_as_pdf,
        'label': 'PDF Files',
        'count': extensionCounts['pdf'],
        'color': BColors.pdfFiles
      },
      {
        'icon': Icons.slideshow,
        'label': 'PPT Files',
        'count': (extensionCounts['ppt'] ?? 0) + (extensionCounts['pptx'] ?? 0),
        'color': BColors.pptFiles
      },
      {
        'icon': Icons.insert_drive_file,
        'label': 'Word Files',
        'count': (extensionCounts['doc'] ?? 0) + (extensionCounts['docx'] ?? 0),
        'color': BColors.wordFiles
      },
      {
        'icon': Icons.table_chart,
        'label': 'Excel Files',
        'count': (extensionCounts['xls'] ?? 0) + (extensionCounts['xlsx'] ?? 0),
        'color': BColors.excelFiles
      },
      {
        'icon': Icons.grid_on,
        'label': 'Sheet Files',
        'count': extensionCounts['xls'] ?? 0,
        'color': BColors.sheetFiles
      },
      {
        'icon': Icons.description,
        'label': 'Text Files',
        'count': extensionCounts['txt'],
        'color': BColors.textFiles
      },
      {
        'icon': Icons.archive,
        'label': 'Zip Files',
        'count': extensionCounts['zip'],
        'color': BColors.zipFiles
      },
      {
        'icon': Icons.bookmark,
        'label': 'Bookmark Files',
        'count': 0,
        'color': BColors.bookmarkedFiles
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final docs = _generateDocStats();

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
                        itemCount: docs.length,
                        itemBuilder: (context, index){
                          final doc = docs[index];
                          return _buildGridButton(
                            icon: doc['icon'],
                            label: doc['label'],
                            count: doc['count'],
                            color: doc['color'],
                            onPressed: () async {
                              final status = await Permission.manageExternalStorage.request();
                              if (status.isGranted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentPage(
                                      title: doc['label'],
                                      color: doc['color'],
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Permission required to access documents.")),
                                );
                                if (status.isPermanentlyDenied) openAppSettings();
                              }
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
  }) {
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