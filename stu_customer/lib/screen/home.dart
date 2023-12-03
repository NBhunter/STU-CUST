import 'package:flutter/material.dart';
import 'package:stu_customer/component/gridItem.dart';
import 'package:stu_customer/core/utils/image_constant.dart';
import 'package:stu_customer/core/utils/size_utils.dart';
import 'package:stu_customer/screen/widgets/custom_image_view.dart';
import 'package:stu_customer/screen/widgets/custom_search_view.dart';
import 'package:stu_customer/screen/widgets/listfavorite_item_widget.dart';
import 'package:stu_customer/screen/widgets/listpngwing_item_widget.dart';
import 'package:stu_customer/theme/app_style.dart';

class HomePage extends StatelessWidget {
  TextEditingController inputFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        width: double.maxFinite,
        padding: getPadding(
          top: 26,
          bottom: 26,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomSearchView(
              focusNode: FocusNode(),
              controller: inputFieldController,
              hintText: "Nhập điểm đến",
              margin: getMargin(
                left: 16,
                right: 16,
              ),
              prefix: Container(
                margin: getMargin(
                  left: 12,
                  top: 12,
                  right: 8,
                  bottom: 12,
                ),
                child: CustomImageView(
                  svgPath: ImageConstant.imgSearch,
                ),
              ),
              prefixConstraints: BoxConstraints(
                maxHeight: getVerticalSize(
                  44,
                ),
              ),
              suffix: Container(
                margin: getMargin(
                  left: 30,
                  top: 12,
                  right: 12,
                  bottom: 12,
                ),
                child: CustomImageView(
                  svgPath: ImageConstant.imgMicrophone,
                ),
              ),
              suffixConstraints: BoxConstraints(
                maxHeight: getVerticalSize(
                  44,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: getVerticalSize(
                  147,
                ),
                child: ListView.separated(
                  padding: getPadding(
                    left: 16,
                    top: 26,
                  ),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: getVerticalSize(
                        24,
                      ),
                    );
                  },
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return ListpngwingItemWidget();
                  },
                ),
              ),
            ),
            Padding(
              padding: getPadding(
                left: 16,
                top: 37,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtGilroySemiBold24Gray90001,
                  ),
                  Padding(
                    padding: getPadding(
                      top: 1,
                      bottom: 7,
                    ),
                    child: Text(
                      "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtGilroySemiBold16BlueA700,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: getVerticalSize(
                  297,
                ),
                child: ListView.separated(
                  padding: getPadding(
                    left: 16,
                    top: 26,
                  ),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: getVerticalSize(
                        16,
                      ),
                    );
                  },
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListfavoriteItemWidget();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
