import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koumi_app/view/item/components/item_gridview.dart';

import '../../size_config.dart';
class ItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ItemGridView(),
    );
  }
}