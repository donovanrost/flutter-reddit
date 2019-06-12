import 'package:flutter/cupertino.dart';
import 'package:helius/common/common.dart';
import '../styles.dart';

class SubredditListItem extends StatelessWidget {
  const SubredditListItem({this.item, this.lastItem, this.bloc});

  final item;
  final bool lastItem;
  final bloc;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              SubmissionThumbnail(submission: item),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(children: <Widget>[
                    Text(item.title, style: Styles.productRowItemName),
                    if (!item.isRedditMediaDomain)
                      Text(
                        '(${item.domain.toString()})',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w100),
                      ),
                    if (item.spoiler) Flair(flairText: 'SPOILER'),
                  ]),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  SubredditListItemBottomBar(item: item)
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Button(
                  onTap: () => bloc.upvote(submission: item),
                  iconData: CupertinoIcons.up_arrow,
                  color: CupertinoColors.activeOrange,
                  size: 40,
                  selected: _isVoted(item.vote, 'upvoted')),
              Button(
                  onTap: () => bloc.downvote(submission: item),
                  iconData: CupertinoIcons.down_arrow,
                  color: CupertinoColors.destructiveRed,
                  size: 40,
                  selected: _isVoted(item.vote, 'downvoted')),
            ],
          )
        ],
      ),
    );

    if (lastItem) {
      // print(item.toString());
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 0,
          ),
          child: Container(
            height: 1,
            color: Styles.productRowDivider,
          ),
        ),
      ],
    );
  }

  _isVoted(vote, whichVote) {
    vote = vote.toString().split('.').last;
    return (vote == whichVote) ? true : false;
  }
}

class SubmissionThumbnail extends StatelessWidget {
  final submission;
  SubmissionThumbnail({@required this.submission});

  _isGif(item) {
    return (!item.preview.isEmpty &&
            (item.preview[0].source.url.toString().contains('.gif')))
        ? true
        : false;
  }

  Widget _chooseThumbnail(context, item) {
    return (item.isSelf)
        ? _thumbnailSelf(context, item)
        : _thumbnailImage(context, item);
  }

  Widget _thumbnailStack(BuildContext context, item) {
    return Stack(
      children: <Widget>[
        _chooseThumbnail(context, item),
        // Positioned(bottom: 2, right: 2, child: _thumbnailIcon(context, item))
      ],
    );
  }

  //TODO Finish this Widget.
  // I have to make custon assets for the Icons
  // The icons dont look nice centered in the container
  Widget _thumbnailIcon(BuildContext context, item) {
    if (item.isVideo) {
      return Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          alignment: Alignment.center,
          child: Icon(
            CupertinoIcons.play_arrow_solid,
            color: CupertinoColors.darkBackgroundGray,
            size: 18,
          ));
    } else if (_isGif(item)) {
      return Container(
        child: Text('GIF'),
        decoration: BoxDecoration(
            color: CupertinoColors.lightBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(4))),
      );
    } else if (!item.isRedditMediaDomain) {
      return Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          alignment: Alignment.center,
          child: Icon(
            CupertinoIcons.bookmark,
            color: CupertinoColors.darkBackgroundGray,
            size: 18,
          ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _thumbnailImage(BuildContext context, item) {
    if (item.thumbnail.toString() == 'spoiler') {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: CupertinoColors.destructiveRed,
        ),
      );
    } else if (item.thumbnail.toString() == 'default') {
      //Apollo shows a fullsize compass
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: CupertinoColors.activeOrange,
        ),
      );
    } else if (item.thumbnail.toString() == 'image') {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: CupertinoColors.activeGreen,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Image.network(
          item.thumbnail.toString(),
          height: 50,
          width: 50,
        ),
      );
    }
  }

  Widget _thumbnailSelf(BuildContext context, item) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.all(Radius.circular(6))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _thumbnailStack(context, submission);
  }
}

class SubredditListItemBottomBar extends StatelessWidget {
  final item;

  SubredditListItemBottomBar({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4,
      spacing: 4,
      children: <Widget>[
        Text(item.author,
            style: TextStyle(
              fontSize: 12.0,
            )),
        if (item.authorFlairText != null && item.authorFlairText.length > 0)
          Flair(flairText: item.authorFlairText),
        if (item.upvotes != null) SubmissionScore(score: item.score),
        if (item.numComments != null)
          SubmissionNumComments(numComments: item.numComments),
        if (item.createdUtc != null) SubmissionAge(createdUtc: item.createdUtc),
        _optionsButton(context, item)
      ],
    );
  }

  _actionSheet(context, item) {
    const x = 10;
    return Container(
        child: CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            actions: <Widget>[
          for (var i = 0; i < x; i++)
            CupertinoActionSheetAction(
                onPressed: () => null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(CupertinoIcons.create),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 24),
                            alignment: Alignment(-1, 0),
                            child: Text('asd')))
                  ],
                )),
        ]));
  }

  _optionsButton(BuildContext context, item) {
    return GestureDetector(
        onTap: () => showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => Container(
                constraints: BoxConstraints(maxHeight: 600),
                child: _actionSheet(context, item))),
        child: Icon(CupertinoIcons.ellipsis));
  }
}
