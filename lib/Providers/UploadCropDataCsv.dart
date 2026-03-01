// import 'package:file_picker/file_picker.dart';

// Future<void> _pickCsvFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//       withData: true, // Important! get bytes for web
//     );

//     if (result != null && result.files.single.bytes != null) {
//       setState(() {
//         _selectedFile = result.files.single;
//       });

//       await uploadCsvWeb(
//           result.files.single.bytes!, result.files.single.name, context);
//     } else {
//       CustomSnackBar.show(
//         context,
//         message: "No file selected",
//         backgroundColor: Colors.orange, // optional
//         icon: Icons.warning, // optional
//         bottomMargin: 40, // optional
//         leftMarginFactor: 0.8, // optional (0.0 left, 0.5 center, 0.8 right)
//       );
//     }
//   }