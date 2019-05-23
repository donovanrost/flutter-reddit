import 'package:flutter/cupertino.dart';
import 'package:helius/home/subreddit_tile_model.dart';

import '../styles.dart';

class SubredditListItem extends StatelessWidget {
  const SubredditListItem({
    this.index,
    // this.subredditTile,
    this.lastItem,
    this.title
  });

  // final SubredditTile subredditTile;
  final int index;
  final bool lastItem;
  final String title;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child:  Row(

        children: <Widget>[
          // Container(
          //     height: 48,
          //     width: 48,
          //     child: Icon(subredditTile.icon,
          //         size: 36, color: CupertinoColors.white),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: subredditTile.iconColor)),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.title,
                    style: Styles.productRowItemName
                  )
                  // Text(
                  //   subredditTile.title,
                  //   style: Styles.productRowItemName,
                  // ),
                  // const Padding(padding: EdgeInsets.only(top: 8)),
                  // Text(
                  //   subredditTile.subtitle,
                  //   style: Styles.productRowItemPrice,
                  // )
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.heart_solid,
              color: CupertinoColors.extraLightBackgroundGray,
              semanticLabel: 'Add',
            ),
            // onPressed: () {
            //   final model = Provider.of<AppStateModel>(context);
            //   model.addProductToCart(product.id);
            // },
          ),
        ],
      ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 16,
          ),
          child: Container(
            height: 1,
            color: Styles.productRowDivider,
          ),
        ),
      ],
    );
  }
}
