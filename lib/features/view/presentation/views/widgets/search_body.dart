import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/shared.dart';
import 'section_header.dart';
import '../../../../Search_White_Bar/presentation/views/widgets/section_search_bar.dart';
import '../../../../Search_White_Bar/presentation/views/widgets/section_city_list.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header Section
          const SectionHeader(),

          // Search Bar Section
          SectionSearchBar(
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
          ),

          // City List Section
          const Expanded(child: SectionCityList()),
        ],
      ),
    );
  }
}
