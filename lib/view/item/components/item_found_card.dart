import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koumi_app/constants.dart';
import 'package:koumi_app/models/Stock.dart';
import 'package:koumi_app/models/item.dart';
import 'package:koumi_app/size_config.dart';



class ItemCard extends StatelessWidget {
  ItemCard(this.item);
  final Stock item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Center(
                child: Hero(
                  tag: "tagHero${item.idStock}",
                  child: Image.network(
                    "https://koumi.ml/api-koumi/Stock/${item.idStock}/image",
                    fit: BoxFit.scaleDown,
                    height: getProportionateScreenHeight(150),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Flexible(
              flex: 3,
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${this.item.nomProduit}",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kPrimaryColor,
                              fontSize: getProportionateScreenWidth(16)),
                          maxLines: 2,
                        ),
                        Container(
                          // margin: EdgeInsets.only(top: 10, bottom: 5),
                            child: this.item.prix != null
                                ? Text(
                              "LKR ${this.item.prix!.toString()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                  fontSize: 12),
                              maxLines: 1,
                            )
                                : Container()),
                        Text(
                          "${this.item.codeStock}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontSize: 10),
                          maxLines: 1,
                        )
                      ])),
            )
          ],
        ),
      ),
    );
  }
}
