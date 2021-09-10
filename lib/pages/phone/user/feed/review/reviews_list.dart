import 'package:flutter/material.dart';
import 'package:kz/pages/phone/user/feed/review/review.dart';
import 'package:kz/tools/models/applications/reviews.dart';
import 'package:provider/provider.dart';

class ReviewsList extends StatefulWidget {
  ReviewsList({Key key}) : super(key: key);

  @override
  _ReviewsListState createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  @override
  Widget build(BuildContext context) {
    final review = Provider.of<List<Review>>(context);
    return review.length == 0
        ? Container(
            child: Center(child: Text('Здесь нет отзывов')),
          )
        : ListView.builder(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: review.length,
            itemBuilder: (context, index) {
              return ReviewContainer(review: review[index]);
            },
          );
  }
}
