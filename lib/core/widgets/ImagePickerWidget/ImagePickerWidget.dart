import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<File> images;
  final Function(List<File>) onChanged;
  final int maxImages;

  const ImagePickerWidget({
    super.key,
    required this.images,
    required this.onChanged,
    this.maxImages = 10,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (!mounted) return;

    if (pickedFiles.isNotEmpty) {
      List<File> newImages = [...widget.images]; // Tạo bản sao của images

      for (var img in pickedFiles) {
        if (newImages.length >= widget.maxImages) break;
        newImages.add(File(img.path));
      }

      widget.onChanged(newImages);
    }
  }

  void _removeImage(int index) {
    List<File> newImages = [...widget.images];
    newImages.removeAt(index);
    widget.onChanged(newImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nút chọn ảnh
        GestureDetector(
          onTap: _pickImages,
          child: DottedBorder(
            color: Colors.grey,
            dashPattern: const [8, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            child: Container(
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                "+ Thêm ảnh",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // Preview
        if (widget.images.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ExcludeSemantics(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final file = widget.images[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            file,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Nút xóa
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
