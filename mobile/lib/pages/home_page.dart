import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'add_article_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();

  List<dynamic> posts = [];
  bool isLoading = true;
  String errorMessage = '';

  String searchQuery = '';
  String selectedCategory = 'Semua';

  final Color primaryColor = const Color(0xFFB89A5A);
  final Color backgroundColor = const Color(0xFFFFF8E7);
  final Color textColor = const Color(0xFF5B4636);

  final TextEditingController searchController = TextEditingController();

  final List<String> categoryList = [
    'Semua',
    'Technology',
    'Programming',
    'Gaming',
    'Education',
  ];

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future<void> getPosts() async {
    try {
      final result = await apiService.getPosts();

      if (!mounted) return;

      setState(() {
        posts = List<dynamic>.from(result);
        isLoading = false;
        errorMessage = '';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
    }
  }

  Future<void> openDetail(int postId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          postId: postId,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    await getPosts();
  }

  Future<void> openAddArticle() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddArticlePage(),
      ),
    );

    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    await getPosts();
  }

  List<dynamic> get filteredPosts {
    return posts.where((post) {
      final title = (post['title'] ?? '').toString().toLowerCase();
      final content = (post['content'] ?? '').toString().toLowerCase();
      final category = (post['category'] ?? '').toString();

      final search = searchQuery.toLowerCase().trim();

      final matchesSearch =
          title.contains(search) || content.contains(search);

      final matchesCategory =
          selectedCategory == 'Semua' || category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
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
          'Blog App',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: _buildBody(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: openAddArticle,
        child: const Icon(Icons.add),
      ),
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
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });

                  getPosts();
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

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: getPosts,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
        children: [
          const Text(
            'Artikel',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5B4636),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Baca artikel terbaru di sini.',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 18),

          _buildSearchField(),

          const SizedBox(height: 18),

          _buildCategoryFilter(),

          const SizedBox(height: 22),

          if (posts.isEmpty)
            _buildEmptyPosts()
          else if (filteredPosts.isEmpty)
            _buildNoResult()
          else
            ...filteredPosts.map(
              (post) => _buildArticleCard(post),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        color: Color(0xFF5B4636),
      ),
      decoration: InputDecoration(
        hintText: 'Cari artikel...',
        hintStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: Colors.black38,
        ),

        prefixIcon: Icon(
          Icons.search,
          color: primaryColor,
        ),

        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  searchController.clear();

                  setState(() {
                    searchQuery = '';
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: primaryColor,
                ),
              )
            : null,

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.2),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final category = categoryList[index];
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : textColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyPosts() {
    return Padding(
      padding: const EdgeInsets.only(top: 130),
      child: Column(
        children: [
          Icon(
            Icons.article_outlined,
            size: 50,
            color: primaryColor,
          ),

          const SizedBox(height: 12),

          const Text(
            'Belum ada artikel',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: Color(0xFF5B4636),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResult() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: primaryColor,
          ),

          const SizedBox(height: 12),

          const Text(
            'Artikel tidak ditemukan',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5B4636),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Coba gunakan kata kunci atau kategori lain.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(dynamic post) {
    return Card(
      color: Colors.white,
      elevation: 1,

      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: primaryColor.withValues(alpha: 0.25),
        ),
      ),

      child: InkWell(
        onTap: () {
          openDetail(post['id']);
        },

        borderRadius: BorderRadius.circular(10),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                post['title'] ?? '',
                style: const TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B4636),
                ),
              ),

              const SizedBox(height: 9),

              Text(
                post['content'] ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  Text(
                    post['category'] ?? 'Tanpa Kategori',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}