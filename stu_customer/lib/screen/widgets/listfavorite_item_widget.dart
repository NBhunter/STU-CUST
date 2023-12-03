import 'package:stu_customer/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListfavoriteItemWidget extends StatelessWidget {
  ListfavoriteItemWidget();

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: getPadding(
            right: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: getVerticalSize(
                  120,
                ),
                width: getHorizontalSize(
                  118,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        margin: EdgeInsets.all(0),
                        color: ColorConstant.whiteA700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyle.roundedBorder6,
                        ),
                        child: Container(
                          height: getVerticalSize(
                            120,
                          ),
                          width: getHorizontalSize(
                            118,
                          ),
                          padding: getPadding(
                            all: 8,
                          ),
                          decoration: AppDecoration.outlineGray700111.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder6,
                          ),
                          child: Stack(
                            children: [
                              CustomImageView(
                                svgPath: ImageConstant.imgFavorite,
                                height: getSize(
                                  24,
                                ),
                                width: getSize(
                                  24,
                                ),
                                alignment: Alignment.topRight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgGrammaphone1,
                      height: getVerticalSize(
                        123,
                      ),
                      width: getHorizontalSize(
                        91,
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Container(
                height: getVerticalSize(
                  72,
                ),
                width: getHorizontalSize(
                  181,
                ),
                margin: getMargin(
                  top: 11,
                ),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtGilroySemiBold16,
                          ),
                          Padding(
                            padding: getPadding(
                              top: 7,
                            ),
                            child: Text(
                              "Current Bid",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtGilroyMedium12,
                            ),
                          ),
                          Padding(
                            padding: getPadding(
                              top: 8,
                            ),
                            child: Text(
                              "2500",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtGilroyMedium16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: getHorizontalSize(
                          77,
                        ),
                        padding: getPadding(
                          left: 12,
                          top: 8,
                          right: 12,
                          bottom: 8,
                        ),
                        decoration: AppDecoration.txtFillBlueA700.copyWith(
                          borderRadius: BorderRadiusStyle.txtRoundedBorder6,
                        ),
                        child: Text(
                          "Bid Now",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtGilroyMedium14WhiteA700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
