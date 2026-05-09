import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "dcf7dogdf";
  final String uploadPreset = "nq2gevdq";

  // Upload 1 ảnh
  Future<String?> uploadImage(File file) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      var request = http.MultipartRequest("POST", url);
      request.fields['upload_preset'] = uploadPreset;

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final data = jsonDecode(resStr);
        return data['secure_url']; // URL ảnh
      } else {
        return null;
      }
    } catch (e) {
      print("Lỗi khi upload ảnh: $e");
      return null;
    }
  }

  // Upload nhiều ảnh
  Future<List<String>> uploadMultipleImages(List<File> files) async {
    final results = await Future.wait(
      files.map((file) async {
        try {
          return await uploadImage(file);
        } catch (e) {
          return null;
        }
      }),
    );
    return results.whereType<String>().toList();
  }
}
