import 'dart:ui';

import 'package:cropbio/API/UploadCsv.dart';
import 'package:cropbio/Widgets/CustomSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert';

class UploadSection extends StatefulWidget {
  // final VoidCallback onPostCsv;
  const UploadSection({super.key});

  @override
  State<UploadSection> createState() => _UploadSectionState();
}

class _UploadSectionState extends State<UploadSection> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  List<List<String>> csvData = [];
  PlatformFile? pickedFile; // <-- store the picked file
  String sendType = "";

  Future<void> pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true, // Important for web: get file bytes
    );

    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single; // <-- save the file
      final bytes = result.files.single.bytes!;
      final csvString = utf8.decode(bytes);
      final fields = const CsvToListConverter().convert(csvString);

      // Convert all values to String
      setState(() {
        pickedFile = file; // make file available to other widgets
        csvData =
            fields.map((row) => row.map((e) => e.toString()).toList()).toList();

        if (csvData.first.toString() ==
            "[FIELD, PLOT, PLANT SAMPLE, CODE, CROP TYPE, FRESH WEIGHT, DRY WEIGHT, Average Leaf Area, Corrected Leaf Area (CF=0.75), Specific Leaf Area (cm2/g), Leaf Dry Matter Content (LDMC), Leaf Water Concentration, Equivalent Water Thickness (EWT), SPAD  values , chl-a, chl-b, carotenoid, Length, Width, Plant, Row, Type, Moisture, Temperature, Plant Height, Cap Cover, LAI, DIFN, MTA, SEM, SMP, SEL, Chloropyll  Value (mg/m2)]") {
          sendType = "summary";
        } else if (csvData.first.toString() ==
            "[FIELD, PLOT, PLANT SAMPLE, CODE, Lat, Lon, Length, Width, Plant Spacing, Row Spacing, Soil Type, Soil Moisture, Soil Temperature, Plant Height]") {
          sendType = "plots";
        } else {
          sendType = "none";
        }
      });

      // print(csvData.first);
      print(sendType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              const Text(
                "Data Uploader: ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6A432),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                ),
                onPressed: pickCsvFile,
                icon: const Icon(Icons.upload_file, color: Colors.black),
                label: const Text(
                  "Upload CSV",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              csvData.isEmpty
                  ? Container()
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 198, 70, 50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 18),
                      ),
                      onPressed: () {
                        setState(() {
                          csvData = [];
                        });
                      },
                      icon:
                          const Icon(Icons.close_outlined, color: Colors.black),
                      label: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
              SizedBox(
                width: 20,
              ),
                     csvData.isEmpty
                  ? Container()
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 99, 198, 50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 18),
                      ),
                      onPressed: () {
                        showGlassDialog(context);
                      },
                      icon:
                          const Icon(Icons.storage_rounded, color: Colors.black),
                      label: const Text(
                        "Store in Database",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // --- CSV Viewer Container ---
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: csvData.isEmpty
                  ? const Center(child: Text("No CSV uploaded yet"))
                  : ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor:
                            WidgetStateProperty.all(const Color(0xFF7A8F3D)),
                        thickness: WidgetStateProperty.all(8),
                      ),
                      child: Scrollbar(
                        controller: _verticalController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _verticalController,
                          scrollDirection: Axis.vertical,
                          child: Scrollbar(
                            controller: _horizontalController,
                            thumbVisibility: true,
                            notificationPredicate: (notification) {
                              return notification.depth == 1; // VERY IMPORTANT
                            },
                            child: SingleChildScrollView(
                              controller: _horizontalController,
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: csvData.first
                                    .map(
                                      (header) => DataColumn(
                                        label: Text(
                                          header,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                rows: csvData
                                    .sublist(1)
                                    .map(
                                      (row) => DataRow(
                                        cells: row
                                            .map((cell) => DataCell(Text(cell)))
                                            .toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
        ),
        const SizedBox(height: 20),

        csvData.isEmpty
            ? Container()
            : Row(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.black54),
                          SizedBox(width: 10),
                          sendType == "summary"
                              ? Text(
                                  "${pickedFile!.name.toString()} will be stored in the OVERVIEW collection",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : sendType == "plots"
                                  ? Text(
                                      "${pickedFile!.name.toString()} will be stored in the PLOTS collection",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : Text(
                                      "${pickedFile!.name.toString()}  not Identified",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
      ],
    );
  }

  void showGlassDialog(BuildContext parentContext) {
    String? selectedYear;
    String? selectedSeason;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: parentContext,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: 420,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Additional Information",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// YEAR DROPDOWN
                            DropdownButtonFormField<String>(
                              value: selectedYear,
                              dropdownColor: Colors.black87,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorStyle:
                                    const TextStyle(color: Colors.redAccent),
                              ),
                              hint: const Text(
                                "Select Year",
                                style: TextStyle(color: Colors.white),
                              ),
                              items: List.generate(
                                50,
                                (index) {
                                  final year =
                                      (DateTime.now().year - index).toString();
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(
                                      year,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a year";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedYear = value;
                                });
                              },
                            ),

                            const SizedBox(height: 20),

                            /// SEASON DROPDOWN
                            DropdownButtonFormField<String>(
                              value: selectedSeason,
                              dropdownColor: Colors.black87,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorStyle:
                                    const TextStyle(color: Colors.redAccent),
                              ),
                              hint: const Text(
                                "Select Season",
                                style: TextStyle(color: Colors.white),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Dry",
                                  child: Text(
                                    "Dry Season",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Wet",
                                  child: Text(
                                    "Wet Season",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a season";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedSeason = value;
                                });
                              },
                            ),

                            const SizedBox(height: 25),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent.shade400,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pop(dialogContext);

                                  if (sendType == "summary") {
                                    if (pickedFile != null &&
                                        pickedFile!.bytes != null) {
                                      await uploadCropData(
                                          pickedFile!.bytes!, // CSV bytes
                                          pickedFile!.name, // CSV file name
                                          selectedYear!,
                                          selectedSeason!,
                                          ).then(
                                        (value) {
                                          if (value["success"]) {
                                            if (value["inserted_count"] > 0) {
                                              CustomSnackBar.show(
                                                parentContext,
                                                message:
                                                    "${value["inserted_count"]} items Uploaded Successfully",
                                                backgroundColor:
                                                    Colors.green, // optional
                                                icon: Icons
                                                    .check_circle, // optional
                                                bottomMargin: 40, // optional
                                                leftMarginFactor:
                                                    0.8, // optional (0.0 left, 0.5 center, 0.8 right)
                                              );
                                            } else {
                                              CustomSnackBar.show(
                                                parentContext,
                                                message: "All records are already in the database",
                                                backgroundColor:
                                                    Colors.orange, // optional
                                                icon: Icons.warning, // optional
                                                bottomMargin: 40, // optional
                                                leftMarginFactor:
                                                    0.8, // optional (0.0 left, 0.5 center, 0.8 right)
                                              );
                                            }
                                          }
                                         } );
                                    } else {
                                      // Show error if no file picked
                                      ScaffoldMessenger.of(parentContext)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("No CSV file selected!"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else if (sendType == "plots") {
                                    if (pickedFile != null &&
                                        pickedFile!.bytes != null) {
                                      await uploadPlotData(
                                              pickedFile!.bytes!, // CSV bytes
                                              pickedFile!.name, // CSV file name
                                              selectedYear!,
                                              selectedSeason!)
                                          .then(
                                        (value) {
                                          if (value["success"]) {
                                            if (value["inserted_count"] > 0) {
                                              CustomSnackBar.show(
                                                parentContext,
                                                message:
                                                    "${value["inserted_count"]} items Uploaded Successfully",
                                                backgroundColor:
                                                    Colors.green, // optional
                                                icon: Icons
                                                    .check_circle, // optional
                                                bottomMargin: 40, // optional
                                                leftMarginFactor:
                                                    0.8, // optional (0.0 left, 0.5 center, 0.8 right)
                                              );
                                            } else {
                                              CustomSnackBar.show(
                                                parentContext,
                                                message: "All records are already in the database",
                                                backgroundColor:
                                                    Colors.orange, // optional
                                                icon: Icons.warning, // optional
                                                bottomMargin: 40, // optional
                                                leftMarginFactor:
                                                    0.8, // optional (0.0 left, 0.5 center, 0.8 right)
                                              );
                                            }
                                          } else {
                                            CustomSnackBar.show(
                                              parentContext,
                                              message: "${value["message"]}",
                                              backgroundColor:
                                                  Colors.orange, // optional
                                              icon: Icons.warning, // optional
                                              bottomMargin: 40, // optional
                                              leftMarginFactor:
                                                  0.8, // optional (0.0 left, 0.5 center, 0.8 right)
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      CustomSnackBar.show(
                                        parentContext,
                                        message: "No CSV file selected!",
                                        backgroundColor:
                                            Colors.orange, // optional
                                        icon: Icons.warning, // optional
                                        bottomMargin: 40, // optional
                                        leftMarginFactor:
                                            0.8, // optional (0.0 left, 0.5 center, 0.8 right)
                                      );
                                    }
                                  } else {
                                    print("Error");
                                  }

                                  // 🔥 Call your post function here
                                }
                              },
                              child: const Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
