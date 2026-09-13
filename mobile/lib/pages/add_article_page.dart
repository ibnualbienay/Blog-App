import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final ApiService apiService = ApiService();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

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
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      final result = await apiService.getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
        isLoadingCategory = false;
        errorMessage = '';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        isLoadingCategory = false;
      });
    }
  }

  Future<void> saveArticle() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await apiService.createPost(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        categoryId: selectedCategory!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Artikel berhasil dibuat',
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
          'Tambah Artikel',
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
              ? _buildError()
              : _buildForm(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 45,
              color: primaryColor,
            ),

            const SizedBox(height: 12),

            const Text(
              'Gagal mengambil kategori',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B4636),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoadingCategory = true;
                  errorMessage = '';
                });

                getCategories();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
          ],
        ),
      ),
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
            const Text(
              'Tulis Artikel',
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B4636),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Bagikan tulisan kamu melalui blog ini.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 28),

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
              textInputAction: TextInputAction.next,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.3,
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

            const SizedBox(height: 22),

            const Text(
              'Isi Artikel',
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
              maxLines: 10,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Color(0xFF5B4636),
              ),
              decoration: InputDecoration(
                hintText: 'Tulis isi artikel di sini...',
                hintStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.3,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Isi artikel wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 22),

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
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Pilih kategori',
                hintStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 1.3,
                  ),
                ),
              ),
              dropdownColor: Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
              ),
              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(
                    category['name'],
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 15,
                      color: Color(0xFF5B4636),
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
                onPressed: isSaving ? null : saveArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      primaryColor.withValues(alpha: 0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                        'Simpan Artikel',
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