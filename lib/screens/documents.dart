import 'package:batoro/utils/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class DocumentPage extends StatefulWidget {
  final String title;
  final Color color;

  const DocumentPage({super.key, required this.title, required this.color});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PlatformFile> _documents = [];
  bool _isPermissionChecked = false; // To track if permission has been requested

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPermissionChecked) {
      _requestStoragePermission();
      _isPermissionChecked = true; // Set to true so we only request permission once
    }
  }

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    // Request storage permission
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      // Permission granted, proceed with scanning storage
      print("Storage permission granted");
      // Call your function to scan storage here
    } else if (status.isDenied) {
      // Permission denied, show a dialog or message to the user
      print("Storage permission denied");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required to access files.")),
      );
    } else if (status.isPermanentlyDenied) {
      // If permanently denied, direct the user to app settings
      openAppSettings();
    }
  }


  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'ppt', 'docx', 'xlsx','xls', 'txt', 'zip'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _documents = result.files;
      });
    }
  }

  String _formatFileSize(int size) {
    // Format file size to a readable format
    if (size < 1024) return "$size B";
    if (size < 1048576) return "${(size / 1024).toStringAsFixed(1)} KB";
    return "${(size / 1048576).toStringAsFixed(1)} MB";
  }

  Future<String> _getFileDate(String? path) async {
    if (path == null) return "Unknown Date";
    final file = File(path);
    final lastModified = await file.lastModified();
    return DateFormat('dd/MM/yyyy').format(lastModified);
  }

  String _getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  Icon _getFileIcon(String fileName) {
    String extension = _getFileExtension(fileName);
    switch (extension) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: BColors.pdfFiles);
      case 'ppt':
      case 'pptx':
        return const Icon(Icons.slideshow, color: BColors.pptFiles);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: BColors.wordFiles);
      case 'xls':
        return const Icon(Icons.table_chart, color: BColors.excelFiles);
      case 'xlsx':
        return const Icon(Icons.grid_on, color: BColors.sheetFiles);
      case 'txt':
        return const Icon(Icons.text_snippet, color: BColors.textFiles);
      case 'zip':
      case 'rar':
        return const Icon(Icons.archive, color: BColors.zipFiles);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BColors.lightGrey,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: BColors.white)),
        backgroundColor: widget.color,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back arrow here
        ),
      ),
      body: Center(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: BColors.white,
                  ),
                  child: Column(
                    children: [
                      Text('${_documents.length} Files', style: const TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w600)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _documents.length,
                          itemBuilder: (context, index){
                            final file = _documents[index];
                            return FutureBuilder<String>(
                              future: _getFileDate(file.path),
                              builder: (context, snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting){
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: _getFileIcon(file.name),
                                      title: Text(file.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      subtitle: Text("${_formatFileSize(file.size)} • Loading...", style: const TextStyle(color: Colors.grey)),
                                      trailing: const Icon(Icons.more_vert),
                                    ),
                                  );
                                } else if (snapshot.hasError){
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: _getFileIcon(file.name),
                                      title: Text(
                                        file.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "${_formatFileSize(file.size)} • Error",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      trailing: const Icon(Icons.more_vert),
                                    ),
                                  );
                                } else {
                                  final lastModified = snapshot.data ?? "Unknown Date";
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: _getFileIcon(file.name),
                                      title: Text(
                                        file.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "${_formatFileSize(file.size)} • $lastModified",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      trailing: const Icon(Icons.more_vert),
                                    ),
                                  );
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
            ),
          ],
        ),
      ),
    );
  }
}
