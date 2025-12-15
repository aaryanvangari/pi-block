import 'package:flutter/material.dart';

class CustomExpansionTileWidget extends StatelessWidget {
  const CustomExpansionTileWidget({
    super.key,
    required this.headerItems,
    required this.contentTitleItems,
    required this.contentValueItems,
    required this.isHeaderARow,
  });
  final List<Widget> headerItems;
  final List<Widget> contentTitleItems;
  final List<Widget> contentValueItems;
  final bool isHeaderARow;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      minVerticalPadding: 0,
      enableFeedback: true,
      child: ExpansionTile(
        showTrailingIcon: false,
        backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(30),
        childrenPadding: EdgeInsets.all(10),
        tilePadding: EdgeInsets.zero,
        dense: true,
        // visualDensity: VisualDensity.compact,
        expandedAlignment: Alignment.topLeft,
        // collapsedShape: RoundedRectangleBorder(
        //   side: BorderSide.none,
        //   // borderRadius: BorderRadius.circular(10),
        // ),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          // borderRadius: BorderRadius.circular(10),
        ),
        title: Container(
          width: MediaQuery.sizeOf(context).width * 0.98,
          // height: MediaQuery.sizeOf(context).width * 0.35,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          // decoration: BoxDecoration(
          //   // borderRadius: BorderRadius.circular(10),
          //   // color: listHeaderBackground.value,
          //   // border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))
          // ),
          child: isHeaderARow
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: headerItems,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: headerItems,
                      ),
                    ),
                  ],
                ),
        ),
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: contentTitleItems,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: contentValueItems,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
