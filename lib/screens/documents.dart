import 'dart:io';
import 'package:batoro/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class DocumentPage extends StatefulWidget {
  final String title;
  final Color color;

  const DocumentPage({super.key, required this.title, required this.color});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FileSystemEntity> _documents = [];
  final List<String> _allowedExtensions = ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'zip'];

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        _scanDeviceForDocuments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission required to access documents.")),
        );
        if (status.isPermanentlyDenied) openAppSettings();
      }
    } else if (Platform.isIOS) {
      _scanDeviceForDocuments(); // iOS uses sandboxed access
    }
  }

  void _scanDeviceForDocuments() async {
    final dir = Directory('/storage/emulated/0/Documents');
    if (await dir.exists()) {
      final allFiles = dir.listSync(recursive: true, followLinks: false);
      final filteredFiles = allFiles.where((file) {
        if (file is File) {
          final ext = path.extension(file.path).replaceFirst('.', '').toLowerCase();
          return _allowedExtensions.contains(ext);
        }
        return false;
      }).toList();

      setState(() {
        _documents = filteredFiles;
      });
    }
  }

  String _formatFileSize(int size) {
    if (size < 1024) return "$size B";
    if (size < 1048576) return "${(size / 1024).toStringAsFixed(1)} KB";
    return "${(size / 1048576).toStringAsFixed(1)} MB";
  }

  Future<String> _getFileDate(String filePath) async {
    final file = File(filePath);
    final lastModified = await file.lastModified();
    return DateFormat('dd/MM/yyyy').format(lastModified);
  }

  Icon _getFileIcon(String fileName) {
    final extension = path.extension(fileName).replaceFirst('.', '').toLowerCase();
    switch (extension) {
      case 'pdf': return const Icon(Icons.picture_as_pdf, color: BColors.pdfFiles);
      case 'ppt':
      case 'pptx': return const Icon(Icons.slideshow, color: BColors.pptFiles);
      case 'doc':
      case 'docx': return const Icon(Icons.description, color: BColors.wordFiles);
      case 'xls':
      case 'xlsx': return const Icon(Icons.grid_on, color: BColors.sheetFiles);
      case 'txt': return const Icon(Icons.text_snippet, color: BColors.textFiles);
      case 'zip': return const Icon(Icons.archive, color: BColors.zipFiles);
      default: return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BColors.lightGrey,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: BColors.white)),
        backgroundColor: widget.color,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Search Files...',
              backgroundColor: Colors.white,
              padding: const EdgeInsetsDirectional.symmetric(vertical: 15),
              onChanged: (query) {
                setState(() {
                  _documents = _documents.where((file) => path.basename(file.path).toLowerCase().contains(query.toLowerCase())).toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                final file = _documents[index] as File;
                return FutureBuilder<String>(
                  future: _getFileDate(file.path),
                  builder: (context, snapshot) {
                    final fileName = path.basename(file.path);
                    final fileSize = file.lengthSync();
                    final fileDate = snapshot.data ?? "Unknown";

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: _getFileIcon(fileName),
                        title: Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${_formatFileSize(fileSize)} • $fileDate", style: const TextStyle(color: Colors.grey)),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
