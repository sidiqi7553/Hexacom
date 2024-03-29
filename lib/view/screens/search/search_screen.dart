import 'package:emarket_user/view/screens/search/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/search_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_provider.dart';
import '../../../utill/styles.dart';
import '../../base/custom_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).cardColor,
        title: Image.asset(Images.logo, width: 70, height: 80),
        actions: [
          // IconButton(
          //   onPressed: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
          //   icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).textTheme.bodyText1.color),
          // ),
          // ResponsiveHelper.isTab(context) ?
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.getNotificationRoute()),
                icon: SvgPicture.asset("assets/icon/bell.svg",
                    semanticsLabel: 'A red up arrow'),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(
                    context, Routes.getDashboardRoute('cart')),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset("assets/icon/bag.svg",
                        semanticsLabel: 'A red up arrow'),
                    Positioned(
                      bottom: -7,
                      left: -7,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Center(
                          child: Text(
                            "\$" +
                                Provider.of<CartProvider>(context)
                                    .cartList
                                    .length
                                    .toString(),
                            style: rubikMedium.copyWith(
                                color: Colors.white, fontSize: 8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
          // : SizedBox(),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 1170,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText:
                                  getTranslated('search_items_here', context),
                              isShowBorder: true,
                              isShowSuffixIcon: true,
                              suffixIconUrl: Images.search,
                              onSuffixTap: () {
                                if (_searchController.text.length > 0) {
                                  searchProvider.saveSearchAddress(
                                      _searchController.text);
                                  searchProvider.searchProduct(
                                      _searchController.text, context);
                                  Navigator.pushNamed(
                                      context,
                                      Routes.getSearchResultRoute(
                                          _searchController.text),
                                      arguments: SearchResultScreen(
                                          searchString:
                                              _searchController.text));
                                }
                              },
                              controller: _searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onSubmit: (text) {
                                if (_searchController.text.length > 0) {
                                  searchProvider.saveSearchAddress(
                                      _searchController.text);
                                  searchProvider.searchProduct(
                                      _searchController.text, context);
                                  Navigator.pushNamed(
                                      context,
                                      Routes.getSearchResultRoute(
                                          _searchController.text),
                                      arguments: SearchResultScreen(
                                          searchString:
                                              _searchController.text));
                                }
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                getTranslated('cancel', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        color:
                                            ColorResources.getGreyBunkerColor(
                                                context)),
                              ))
                        ],
                      ),
                      // for resent search section
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('recent_search', context),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    color: ColorResources.COLOR_GREY_BUNKER),
                          ),
                          searchProvider.historyList.length > 0
                              ? TextButton(
                                  onPressed: searchProvider.clearSearchAddress,
                                  child: Text(
                                    getTranslated('remove_all', context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            color: ColorResources
                                                .COLOR_GREY_BUNKER),
                                  ))
                              : SizedBox.shrink(),
                        ],
                      ),

                      // for recent search list section
                      Expanded(
                        child: ListView.builder(
                            itemCount: searchProvider.historyList.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    searchProvider.searchProduct(
                                        searchProvider.historyList[index],
                                        context);
                                    Navigator.pushNamed(
                                        context,
                                        Routes.getSearchResultRoute(
                                            searchProvider.historyList[index]));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.history,
                                                size: 16,
                                                color:
                                                    ColorResources.COLOR_HINT),
                                            SizedBox(width: 13),
                                            Text(
                                              searchProvider.historyList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      color: ColorResources
                                                          .COLOR_HINT,
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_SMALL),
                                            )
                                          ],
                                        ),
                                        Icon(Icons.arrow_upward,
                                            size: 16,
                                            color: ColorResources.COLOR_HINT),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
