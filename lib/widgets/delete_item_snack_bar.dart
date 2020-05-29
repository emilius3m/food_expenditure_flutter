import 'package:flutter/material.dart';
import 'package:spesa_repository/spesa_repository.dart';

class DeleteItemSnackBar extends SnackBar {
  DeleteItemSnackBar({
    Key key,
    @required Item item,
    @required VoidCallback onUndo,
  }) : super(
          key: key,
          content: Text(
            'Deleted ${item.product}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: onUndo,
          ),
        );
}
