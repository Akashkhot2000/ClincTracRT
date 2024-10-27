import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/brief_case/models/brief_case_response.dart';
import 'package:clinicaltrac/view/brief_case/view/upload_document_bottom_sheet.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class BriefCaseScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;

  BriefCaseScreen({super.key, required this.userLoginResponse});

  @override
  State<BriefCaseScreen> createState() => _BriefCaseScreenState();
}

class _BriefCaseScreenState extends State<BriefCaseScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = false;
  bool dataNotFound = false;
  TextEditingController searchQuery = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<BriefCaseInnerData> briefCaseList = [];

  dynamic progress = 0;

  int noOfDownloads = 0;

  final ReceivePort _receivePort = ReceivePort();
  bool isBackButtonActivated = true;

  void getbriefcaseList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest elvationMasteryRequest = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text);
      final DataResponseModel dataResponseModel =
          await dataService.getBriefCase(elvationMasteryRequest);
      BriefCaseResponse briefCaseResponse =
          BriefCaseResponse.fromJson(dataResponseModel.data);
      // log("Total Record ---- ${briefCaseResponse.payload!.pager!.totalRecords}");
      lastpage =
          (int.parse(briefCaseResponse.payload!.pager!.totalRecords!) / 10)
              .ceil();
      if (briefCaseResponse.payload!.pager!.totalRecords == '0') {
        setState(() {
          dataNotFound = true;
        });
      } else {
        setState(() {
          dataNotFound = false;
        });
      }
      setState(() {
        if (pageNo != 1) {
          briefCaseList.addAll(briefCaseResponse.payload!.data!);
        } else {
          briefCaseList = briefCaseResponse.payload!.data!;
        }
        isDataLoaded = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;
      getbriefcaseList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  void initState() {
    getbriefcaseList();
    _scrollController.addListener(_scrollListener);
    super.initState();
    // _backgroundIsolate();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getbriefcaseList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          titles: isSearchClicked
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: searchFocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonSearchTextfield(
                        focusNode: searchFocusNode,
                        hintText: 'Search',
                        textEditingController: searchQuery,
                        onChanged: (value) {
                          pageNo = 1;
                          getbriefcaseList();
                        },
                      ),
                    ),
                  ),
                )
              : Text(
                  " Briefcase",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                ),
          searchEnabeled: true,
          image: !isSearchClicked
              ? SvgPicture.asset(
                  'assets/images/search.svg',
                )
              : SvgPicture.asset(
                  'assets/images/closeicon.svg',
                ),
          onSearchTap: () {
            setState(() {
              isSearchClicked = !isSearchClicked;
              searchQuery.text = '';
              FocusScope.of(context).unfocus();
              if (isSearchClicked == false) getbriefcaseList();
            });
          },
        ),
        backgroundColor: Color(Hardcoded.white),
        // bottomNavigationBar: BottomAppBar(
        //   height: globalHeight * 0.09,
        //   elevation: 0,
        //   child: GestureDetector(
        //     onTap: () {
        //       pickFile();
        //
        //     },
        //     child: Padding(
        //       padding: EdgeInsets.only(
        //           top: 10,
        //           left: globalWidth * 0.05,
        //           right: globalWidth * 0.05,
        //           bottom: 10),
        //       child: Container(
        //
        //         decoration: BoxDecoration(
        //           color:Color(0xFF01A750) ,
        //           borderRadius: BorderRadius.circular(15),
        //           border: Border.all(
        //             color: Color(0xFF01A750),
        //           ),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             SvgPicture.asset('assets/upload_doc.svg') ,
        //             SizedBox(
        //               width: globalWidth * 0.03,
        //             ),
        //
        //             Text(
        //               "Upload Document",
        //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        //                   fontSize: 15,
        //                   fontWeight: FontWeight.w500,
        //                   color:  Color(0xFFFFFFFF)),
        //             ),
        //             SizedBox(
        //               width: globalWidth * 0.01,
        //             ),
        //
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        // ),
        body: Visibility(
          visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: globalHeight * 0.06,
            ),
            child: common_loader(),
          ),
          replacement: Visibility(
            visible: !dataNotFound,
            replacement: isSearchClicked
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                          bottom: globalHeight * 0.06,
                        ),
                        child: NoDataFoundWidget(
                          title: "No data found",
                          imagePath: "assets/no_data_found.png",
                        )),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: globalHeight * 0.06,
                      ),
                      child: NoDataFoundWidget(
                        title: "Briefcase not available",
                        imagePath: "assets/no_data_found.png",
                      ),
                    ),
                  ),
            child: RefreshIndicator(
              onRefresh: () => pullToRefresh(),
              color: Color(0xFFBBBBC6),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromARGB(24, 203, 204, 208),
                      blurRadius: 35.0, // soften the shadow
                      spreadRadius: 10.0, //extend the shadow
                      offset: Offset(
                        15.0,
                        15.0,
                      ),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 2, right: 2.0),
                  child:CupertinoScrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: briefCaseList.length,
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      downloadFileandOpen(
                                          context,
                                          briefCaseList[index].filePath!,
                                          briefCaseList[index].fileName!,
                                          false);
                                    },
                                    child: Container(
                                      color: Colors.white12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, top: 10),
                                            child: SvgPicture.asset(
                                              'assets/file_icon_pdf_' +
                                                  (((index) % 5) + 1)
                                                      .toString() +
                                                  '.svg',
                                              height: globalHeight * 0.06,
                                              width: globalWidth * 0.12,
                                            ),
                                          ),
                                          SizedBox(
                                            width: globalWidth / 1.65,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, left: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: Text(
                                                      briefCaseList[index]
                                                          .fileTitle!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xFF000000),
                                                        fontFamily: 'Poppins',
                                                        fontSize: 15,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0, top: 2),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Uploaded by : ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF868998),
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 12,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                        Text(
                                                          briefCaseList[index]
                                                              .updatedBy!,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF000000),
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 12,
                                                          ),
                                                          maxLines: 2,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.0,
                                                        right: 2.0,
                                                        bottom: 15,
                                                        top: 6),
                                                    child: Text(
                                                        "${DateFormat("MMM dd, yyyy").format(briefCaseList[index].uploadedDate!)}; ${DateFormat("hh:mm aa").format(briefCaseList[index].uploadedDate!)}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xFF868998),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                        ),
                                                        maxLines: 2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      downloadFileandOpen(
                                          context,
                                          briefCaseList[index].filePath!,
                                          briefCaseList[index].fileName!,
                                          true);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 1.0,
                                        right: 10,
                                      ),
                                      child: Container(
                                        height: globalHeight * 0.1,
                                        width: globalWidth * 0.15,
                                        color: Colors.transparent,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, right: 0, bottom: 0),
                                            child: SvgPicture.asset(
                                                'assets/images/pdf_download_button.svg',
                                                height: globalHeight * 0.053,
                                                width: globalWidth * 0.2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Color(0xFFE8E8E8),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void downloadFileandOpen(
    BuildContext context,
    String url,
    String fileName,
    bool isFileDownload,
  ) async {
    var directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();

    String dir = directory!.path;
    if (isFileDownload) {
      if (Platform.isAndroid) {
        var directoryDownload =
            await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS,
        ); //FOR ANDROID Download Dir
        dir = directoryDownload as String;
      } else if (Platform.isIOS) {
        Directory directoryDownloadios =
            await getApplicationDocumentsDirectory();
        dir = directoryDownloadios.path;
      }
    }

    File file = new File('$dir/$fileName');
    print("THE: " + file.path);

    if (isFileDownload) {
      if (await file.exists()) {
        AppHelper.buildErrorSnackbar(context, 'File already downloaded...');
      } else {
        AppHelper.buildErrorSnackbar(context, 'Downloading...');
        AppHelper.buildErrorSnackbar(context, 'File downloaded');
      }
      HttpClient httpClient = new HttpClient();
      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          print(file.path);
          await file.writeAsBytes(bytes);
        }
      } catch (ex) {
        AppHelper.buildErrorSnackbar(context, ex.toString());
        print("eww" + ex.toString());
      } finally {
        if (await file.exists()) {
          // AppHelper.buildSnackbar("File Not Found On Server", Colors.red);
        } else {
          AppHelper.buildErrorSnackbar(context, "File not found on server");
        }
      }
    } else {
      if (await file.exists()) {
        OpenFile.open(file.path);
      } else {
        // AppHelper.CommonLoader();

        HttpClient httpClient = new HttpClient();
        try {
          var request = await httpClient.getUrl(Uri.parse(url));
          var response = await request.close();
          print(response.statusCode);
          if (response.statusCode == 200) {
            var bytes = await consolidateHttpClientResponseBytes(response);
            print(file.path);
            await file.writeAsBytes(bytes);
          }

          //Navigator.pop(context);
        } catch (ex) {
          //Navigator.pop(context);
          AppHelper.buildErrorSnackbar(context, ex.toString());
          print("eww" + ex.toString());
          //Utils.displayToast(context, ex.toString());
        } finally {
          if (await file.exists()) {
            OpenFile.open(file.path);
          } else {
            AppHelper.buildErrorSnackbar(context, "File not found on server");
          }
        }
      }
    }
  }

  void _backgroundIsolate() {
    ///register a send port for the other isolates
    final bool isSucess = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      "downloader_send_port",
    );

    log("isSucess$isSucess");

    if (!isSucess) {
      _unbindBackgroundIsolate();
      _backgroundIsolate();
      noOfDownloads = 0;
      return;
    }

    ///Listening for the data is comming other isolataes
    _receivePort.listen((dynamic message) {
      if (message.toString().isNotEmpty) {
        log('UI Isolate Callback: $message');
      }
      progress = message[2];
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static downloadingCallback(
    String id,
    int status,
    int progress,
  ) {
    print(
      'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)',
    );

    ///Looking up for a send port
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName("downloader_send_port");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }

  Future<void> pickFile() async {
    List<PlatformFile?> selectedPdfFiles = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      selectedPdfFiles = result.files;
      if (selectedPdfFiles.length > 5) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('File Limit Exceeded'),
              content: Text('You can select up to 5 PDF files.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Add the new files to the existing list
        List<PlatformFile> sizeOverPdfList = [];
        for (int i = 0; i < result.files.length; i++) {
          if (result.files.elementAt(i).size > PDF_SIZE_LIMIT) {
            sizeOverPdfList.add(result.files.elementAt(i));
          }
        }
      }
      print("File path: ${file.path}");
      print("File name: ${file.name}");
      print("File size: ${file.size}");
      print("File extension: ${file.extension}");
      print("File bytes: ${file.bytes}");
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return UploadDocumentBottomSheet();
        },
      );
    } else {
      // User canceled the file picking
      print("No file picked.");
    }
  }
}
