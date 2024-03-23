// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';

import 'custom_snackbar.dart';

void main() async {
  runApp(const MaterialApp(
    home: FileUpload(),
  ));
}

class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  FileUploadState createState() => FileUploadState();
}

class FileUploadState extends State<FileUpload> {
  List<FilePickerResult> uploadedFiles = [];

  void previewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: uploadedFiles.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      previewFile(uploadedFiles[index].files.first);
                    },
                    child: _getDocumentListTile(
                        uploadedFiles[index], context, index),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Upload New File'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'docx', 'xlsx', 'mp4'],
      allowMultiple: false,
    );
    if (result != null) {
      if (File(result.files.first.path!).lengthSync() < (10 * 1024 * 1024)) {
        setState(() {
          uploadedFiles.add(result);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          const Text(
            'Please upload file under 10 MB',
            overflow: TextOverflow.visible,
          ),
        ));
      }
    }
  }

  Widget _getDocumentListTile(
      FilePickerResult filePickerResult, BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            color: Colors.white,
            borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              SvgPicture.asset(
                filePickerResult.files.first.name.contains('.pdf')
                    ? 'assets/pdf_image.svg'
                    : filePickerResult.files.first.name.contains('.doc')
                        ? 'assets/docx_image.svg'
                        : filePickerResult.files.first.name.contains('.xlsx')
                            ? 'assets/excel_image.svg'
                            : filePickerResult.files.first.name.contains('.mp4')
                                ? 'assets/mp4_image.svg'
                                : 'assets/jpeg_image.svg',
                width: 54,
                height: 62,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        filePickerResult.files.first.name,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    elevation: 0,
                    builder: (context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                            child: Wrap(
                              children: [
                                SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0,
                                                bottom: 8.0,
                                                left: 18.0,
                                                right: 14.0),
                                            child: Text(
                                              'Delete Document',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        color: Colors.white,
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                              top: 18,
                                              bottom: 10),
                                          child: Text(
                                            'Are you sure want to delete this document?',
                                            style: TextStyle(
                                              fontFamily: 'Heebo',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 50,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.black),
                                              child: const Center(
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.32,
                                                      fontFamily: 'Heebo'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                uploadedFiles.removeAt(index);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 50,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.blue),
                                              child: const Center(
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.32,
                                                      fontFamily: 'Heebo'),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
