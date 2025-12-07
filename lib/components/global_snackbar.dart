import 'package:flutter/material.dart';

class GlobalSnackbar {
  GlobalSnackbar._();
  static error(BuildContext context, String message, String description) {
    SnackBar snackBar = SnackBar(
      // Setting the elevation to 0 to make the snack bar flat
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Card(
        // Rounding the border of the card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // Setting the clipping behavior for the card
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 1,
        child: Container(
          color: Theme.of(context).colorScheme.error,
          // Adding padding to the container
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              // Adding space to the left side
              const SizedBox(width: 5, height: 0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExpansionTile(
                      showTrailingIcon: description.isNotEmpty,
                      dense: true,
                      iconColor: Theme.of(context).colorScheme.onError,
                      collapsedIconColor: Theme.of(context).colorScheme.onError,
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide.none,
                      ),
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      title: Text(
                        message,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 14,
                        ),
                      ),
                      children: <Widget>[
                        description.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                  vertical: 3,
                                ),
                                child: Text(
                                  description,
                                  maxLines: 4,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onError,
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
              // Adding a vertical line between the product name and the undo button
              Container(
                color: Colors.grey,
                height: 25,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 5),
              ),
              IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).colorScheme.onError,
                onPressed: () {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                },
              ),
            ],
          ),
        ),
      ),
      // SnackBar as transparent
      backgroundColor: Colors.transparent,
      // SnackBar duration
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
