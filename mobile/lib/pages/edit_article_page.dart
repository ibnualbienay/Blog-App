import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditArticlePage extends StatefulWidget {
  final dynamic post;

  const EditArticlePage({
    super.key,
    required this.post,
  });

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final ApiService apiService = ApiService();

  final formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController contentController;

  List<dynamic> categories = [];
  int? selectedCategory;

  bool isLoadingCategory = true;
  bool isSaving = false;
  String errorMessage = '';

  final Color primaryColor = const Color(0xFFB89A5A);
  final Color backgroundColor = const Color(0xFFFFF8E7);

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.post['title'] ?? '',
    );

    contentController = TextEditingController(
      text: widget.post['content'] ?? '',
    );

    selectedCategory = int.tryParse(
      widget.post['category_id'].toString(),
    );

    getCategories();
  }

  Future<void> getCategories() async {
    try {
      final result = await apiService.getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
        isLoadingCategory = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        isLoadingCategory = false;
      });
    }
  }

  Future<void> updateArticle() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await apiService.updatePost(
        id: widget.post['id'],
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        categoryId: selectedCategory!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Artikel berhasil diperbarui',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
            ),
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Edit Artikel',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: isLoadingCategory
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ),
                )
              : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit artikel',
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5B4636),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Ubah isi artikel sesuai kebutuhan.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Judul Artikel',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B4636),
              ),
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: titleController,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Color(0xFF5B4636),
              ),
              decoration: InputDecoration(
                hintText: 'Masukkan judul artikel',
                hintStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul artikel wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Konten Artikel',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B4636),
              ),
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: contentController,
              maxLines: 9,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Color(0xFF5B4636),
              ),
              decoration: InputDecoration(
                hintText: 'Tulis isi artikel...',
                hintStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Konten artikel wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Kategori',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B4636),
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                hintText: 'Pilih kategori',
                hintStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(
                    category['name'],
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Kategori wajib dipilih';
                }

                return null;
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : updateArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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