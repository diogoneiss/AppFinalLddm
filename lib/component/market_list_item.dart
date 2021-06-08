import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:app_criptomoedas/model/market_model.dart';
import 'package:app_criptomoedas/component/market_card.dart';

class MarketListItem extends StatelessWidget {
  const MarketListItem({
    Key key,
    @required this.item,
    @required this.onEdit,
    @required this.onDelete,
    @required this.dismissDirection,
    @required this.confirmDismiss,
  }) : super(key: key);

  final MarketModel item;
  final DismissDirection dismissDirection;
  final void Function(MarketModel) onEdit;
  final void Function(MarketModel) onDelete;
  final bool confirmDismiss;

  void _handleEdit() {
    onEdit(item);
  }

  void _handleDelete() {
    onDelete(item);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      customSemanticsActions: <CustomSemanticsAction, VoidCallback>{
        const CustomSemanticsAction(label: 'Archive'): _handleEdit,
        const CustomSemanticsAction(label: 'Delete'): _handleDelete,
      },
      child: Dismissible(
        key: ObjectKey(item),
        direction: dismissDirection,
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.startToEnd)
            _handleDelete();
          else
            _handleEdit();
        },
        confirmDismiss: !confirmDismiss
            ? null
            : (DismissDirection dismissDirection) async {
                switch (dismissDirection) {
                  case DismissDirection.endToStart:
                    return await _showConfirmationDialog(context, 'edit') ==
                        true;
                  case DismissDirection.startToEnd:
                    return await _showConfirmationDialog(context, 'delete') ==
                        true;
                  case DismissDirection.horizontal:
                  case DismissDirection.vertical:
                  case DismissDirection.up:
                  case DismissDirection.down:
                    assert(false);
                }
                return false;
              },
        background: Container(
          color: theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Icon(Icons.delete, color: Colors.white, size: 36.0),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.edit, color: Colors.white, size: 36.0),
              ),
            ],
          ),
        ),
        child: SizedBox(
          height: 120,
          child: MarketCard(
            marketModel: item,
            onPressed: _handleDelete,
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String action) {
    final ThemeData theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to $action this item?'),
          actions: <Widget>[
            FlatButton(
              color: theme.buttonColor,
              child: Text(action.substring(0, 1).toUpperCase() +
                  action.substring(1, action.length)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
