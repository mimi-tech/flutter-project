import 'package:bot_toast/bot_toast.dart';
import 'package:sparks/market/market_services/navigation_service.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/screens/market_profile.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/global_services/service_locator.dart';

class MarketMessaging {
  /// Method that handles FCM onMessage
  static void marketForegroundHandler({required Map<String, dynamic> message}) {
    String? screen = message["data"]["screen"];
    late String displayText;
    Function? callBackFunc;

    switch (screen) {
      case "followed_user":
        String? userId = message["data"]["id"];
        String? userName = message["data"]["un"];

        displayText = "$userName followed your store";

        callBackFunc = () {
          locator<NavigationService>().navigateToWidget(
            MarketProfile(
              userId: userId,
            ),
          );
        };
        break;

      case "product_detail":
        String? commonId = message["data"]["cmId"];
        String? storeId = message["data"]["id"];
        double productRating = double.parse(message["data"]["rate"]);
        String? productCondition = message["data"]["cond"];
        String productCategory = message["data"]["prC"];
        String? productImage = message["data"]["prImg"];
        String? productName = message["data"]["prN"];
        double productPrice = double.parse(message["data"]["price"]);

        MarketBrain.recentlyViewedNeededValues(
            commonId: commonId,
            storeId: storeId,
            rating: productRating,
            condition: productCondition,
            category: productCategory,
            productImg: productImage,
            productName: productName,
            price: productPrice);

        String? storeName = message["data"]["stNm"];

        /// This function that in the product category and returns it in a singular fom
        String singularCategory(String cate) {
          String result = "";

          cate = cate.toLowerCase();

          int lastIndex = cate.length - 1;

          if (cate[lastIndex] == "s") {
            result = cate.substring(0, lastIndex);
          } else {
            result = cate;
          }

          return result;
        }

        /// Assigning the result return from [singularCategory] to a variable
        String singleWordCat = singularCategory(productCategory);

        /// Message to be displayed in the snack bar
        displayText = "$storeName has a new $singleWordCat in their store";

        callBackFunc = () {
          locator<NavigationService>().navigateTo(MarketProfile.id);
        };

        break;

      case "product_rating":
        String? userName = message["data"]["un"];

        displayText = "$userName gave your product a rating";
        callBackFunc = () {
          print("Product rating was clicked");
        };
        break;
    }

    BotToast.showSimpleNotification(
      title: displayText,
      hideCloseButton: true,
      onTap: callBackFunc as void Function()?,
    );
  }

  /// Function that handles FCM background notification
  static Future<void> marketBackgroundHandler(
      {required Map<String, dynamic> message}) async {
    String? screen = message["data"]["screen"];

    switch (screen) {
      case "followed_user":
        String? userId = message["data"]["id"];

        locator<NavigationService>().navigateToWidget(
          MarketProfile(
            userId: userId,
          ),
        );
        break;

      case "product_detail":
        String? commonId = message["data"]["cmId"];
        String? storeId = message["data"]["id"];
        double productRating = double.parse(message["data"]["rate"]);
        String? productCondition = message["data"]["cond"];
        String? productCategory = message["data"]["prC"];
        String? productImage = message["data"]["prImg"];
        String? productName = message["data"]["prN"];
        double productPrice = double.parse(message["data"]["price"]);

        MarketBrain.recentlyViewedNeededValues(
            commonId: commonId,
            storeId: storeId,
            rating: productRating,
            condition: productCondition,
            category: productCategory,
            productImg: productImage,
            productName: productName,
            price: productPrice);

        await locator<NavigationService>().navigateTo(MarketProductDetails.id);

        break;

      /// TODO: Write out the case for product_rating background function
    }
  }
}
