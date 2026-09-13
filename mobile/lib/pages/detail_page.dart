import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_article_page.dart';

class DetailPage extends StatefulWidget {
  final int postId;

  const DetailPage({
    super.key,
    required this.postId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService apiService = ApiService();

  dynamic post;
  bool isLoading = true;
  String errorMessage = '';

  final Color primaryColor = const Color(0xFFB89A5A);
  final Color backgroundColor = const Color(0xFFFFF8E7);

  @override
  void initState() {
    super.initState();
    getPostDetail();
  }

  Future<void> getPostDetail() async {
    try {
      final result = await apiService.getPostById(widget.postId);

      if (!mounted) return;

      setState(() {
        post = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deletePost() async {
    try {
      await apiService.deletePost(widget.postId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Artikel berhasil dihapus',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
            ),
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menghapus artikel: $error',
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
            ),
          ),
        ),
      );
    }
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Artikel',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5B4636),
            ),
          ),
          content: const Text(
            'Apakah kamu yakin ingin menghapus artikel ini?',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: primaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deletePost();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> openEditPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditArticlePage(
          post: post,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      getPostDetail();
    }
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
          'Detail Artikel',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          if (post != null)
            IconButton(
              onPressed: openEditPage,
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
            ),

          if (post != null)
            IconButton(
              onPressed: showDeleteDialog,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus',
            ),
        ],
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
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
                'Gagal mengambil artikel',
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
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });

                  getPostDetail();
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

    if (post == null) {
      return const Center(
        child: Text(
          'Artikel tidak ditemukan',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post['title'] ?? '',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5B4636),
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            post['category'] ?? 'Tanpa kategori',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Divider(
            color: primaryColor.withValues(alpha: 0.25),
          ),

          const SizedBox(height: 20),

          Text(
            post['content'] ?? '',
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              height: 1.7,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}