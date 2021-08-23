import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/market/components/product_listing_next_back_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/market/market_models/cloth_base_model.dart';
import 'package:sparks/market/market_models/product_default_model.dart';
import 'package:sparks/market/market_models/product_home_detail_model.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/components/image_add_icon_and_text.dart';
import 'package:sparks/market/components/custom_image_picker_box.dart';
import 'package:sparks/market/market_models/cloth_product_listing_model.dart';
import 'package:sparks/market/market_services/market_storage_service.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/utilities/market_mixin.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uuid/uuid.dart';

enum ImageView {
  FRONT,
  BACK,
  LEFT,
  RIGHT,
}

enum GalleryOrCamera {
  CAMERA,
  GALLERY,
}

class ProductListingImages extends StatefulWidget {
  final TabController? tabController;

  ProductListingImages({required this.tabController});

  @override
  _ProductListingImagesState createState() => _ProductListingImagesState();
}

class _ProductListingImagesState extends State<ProductListingImages>
    with AutomaticKeepAliveClientMixin, MarketMixin {
  /// Initializing FirebaseAuth Service
  final _auth = FirebaseAuth.instance;

  /// Initializing User Service
  User? _currentUser;

  /// Initializing an ImageView enum object
  ImageView? imageView;

  /// Initializing an instance of the [ImagePicker] from the Image_picker package
  final picker = ImagePicker();

  late ClothProductListingModel clothProductListingModel;

  ProductDefaultModel? productDefaultModel;

  ProductHomeDetailModel? productHomeDetailModel;

  late ClothBaseModel clothBaseModel;

  var uuid = Uuid();

  /// Function to add cloth key words to the database
  List<String> extractClothSearchKeyWords({
    String? productCondition,
    required String productName,
    required String productCategory,
    required String productBrand,
    //String productColor,
    required String clothMaterial,
    required String manufacturer,
    required String subCategory,
  }) {
    if (productCondition == "new product") {
      productCondition = "new";
    } else {
      productCondition = "used";
    }

    /// Regular Expression pattern that validates alphabetic and int numeric values
    RegExp validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

    List<String> searchKeyWords = [];

    String joinedString = "";

    /// Combining the entire method parameters into a String
    joinedString = joinedString +
        productCondition.toLowerCase() +
        " " +
        productName.toLowerCase() +
        " " +
        productCategory.toLowerCase() +
        " " +
        productBrand.toLowerCase() +
        " " +
        manufacturer.toLowerCase() +
        " " +
        subCategory.toLowerCase() +
        " " +
        clothMaterial.toLowerCase();

    HashSet<String> hashSet = new HashSet<String>();

    /// Splitting the combined parameter String value into space-separated words
    ///
    /// NOTE: The splitting uses the RegExp pattern to ensure that the separated
    /// words has either alphabetic or numeric values
    for (int i = 0; i < joinedString.split(" ").length; i++) {
      if (validCharacters.hasMatch(joinedString.split(" ")[i])) {
        hashSet.add(joinedString.split(" ")[i]);
      }
    }

    List<String> temp = hashSet.toList();

    /// Function that takes 2 String arguments and return either TRUE or FALSE
    /// 1st - If the length of the 2 String parameter are greater than 1 = TRUE
    /// 2nd - If both length of the String parameter is equal to 1 = FALSE
    /// 3rd - If either of the String parameter contains a number = TRUE else FALSE
    bool checkLengthAndIfNumberValidity(String first, String second) {
      bool isValid = false;

      HashSet containsNum = new HashSet<String>.from(
          ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);

      if (first.length > 1 && second.length > 1) {
        isValid = true;
      } else if (first.length == 1 && second.length == 1) {
        isValid = false;
      } else {
        if (containsNum.contains(first) || containsNum.contains(second)) {
          isValid = true;
        } else {
          isValid = false;
        }
      }

      return isValid;
    }

    /// Function that return a combination of 2-word pairs
    /// NOTE: This function uses the [checkLengthAndIfNumberValidity]
    int pointer = 0;

    while (pointer < temp.length) {
      for (int i = 0; i < temp.length; i++) {
        if (i != pointer &&
            temp[pointer] != temp[i] &&
            checkLengthAndIfNumberValidity(temp[pointer], temp[i])) {
          hashSet.add(temp[pointer] + " " + temp[i]);
        }
      }

      pointer++;
    }

    /// Function that returns a combination of 3-word pairs
    /// NOTE: This function uses the [validCharacter] Regular Expression
    for (int i = 0; i < temp.length; i++) {
      if (i + 2 < temp.length) {
        if (validCharacters.hasMatch(temp[i]) &&
            validCharacters.hasMatch(temp[i + 1]) &&
            validCharacters.hasMatch(temp[i + 2])) {
          hashSet.add(temp[i] + " " + temp[i + 1] + " " + temp[i + 2]);
        }
      }

      if (i + 3 > temp.length) break;
    }

    hashSet.add(productCategory.toLowerCase());
    hashSet.add(productName.toLowerCase());
    hashSet.add(clothMaterial.toLowerCase());
    hashSet.add(productBrand.toLowerCase());
    hashSet.add(manufacturer.toLowerCase());
    hashSet.add(subCategory.toLowerCase());
    hashSet.add(productCondition);

    searchKeyWords = hashSet.toList();

    return searchKeyWords;
  }

  /// TODO: Remove this method and use the global sparks user object
  /// Function to get the uid of the currently logged in user
  void getCurrentUser() {
    try {
      _currentUser = _auth.currentUser;
      if (_currentUser != null) {
        print(_currentUser!.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  /// File variables to hold the front, back, right and left images
  File? _frontImage;
  File? _backImage;
  File? _rightImage;
  File? _leftImage;

  /// List of File to hold the selected images
  List<File?> _productImages = [];

  static compressProductImage(
      String pickedFilePath, String outputPath, double percentage) async {
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFilePath, outputPath,
        quality: percentage.toInt());
  }

  static testingOne(Map<String, dynamic> data) async {
    String pickedFilePath = data["pickedFilePath"];
    String outputPath = data["outputPath"];
    int percentage = data["percentage"];
    final compressFile = await FlutterImageCompress.compressAndGetFile(
        pickedFilePath, outputPath,
        quality: percentage);
  }

  /// Function to pick image from phone camera
  Future getImageFromCamera(ImageView? imageView) async {
    final pickedFile = await (picker.getImage(source: ImageSource.camera)
        as Future<PickedFile>);

    String pickedFilePath = pickedFile.path;

    final pickedFileByte = await pickedFile.readAsBytes();

    int imageSize = pickedFileByte.lengthInBytes;

    int targetSize = 1024 * 1024 * 5;

    double percentage = (targetSize / imageSize) * 100;

    String getCompressedPath(String imagePath) {
      int? extIndex;
      String newPath;

      for (int i = imagePath.length - 1; i > 0; i--) {
        if (imagePath[i] == ".") {
          extIndex = i;
          break;
        }
      }

      String extensionType = imagePath.substring(extIndex!, imagePath.length);
      String partialPath = imagePath.substring(0, extIndex);

      newPath = "${partialPath}_out$extensionType";

      return newPath;
    }

    if (imageSize > targetSize) {
      /// TODO: Use an Isolate to compress the image
      FlutterIsolate isolateCompressImage;

      String outputPath = getCompressedPath(pickedFilePath);

      isolateCompressImage = await FlutterIsolate.spawn<String>(
          compressProductImage(pickedFilePath, outputPath, percentage),
          "compressing");

      final compressedFile = await (FlutterImageCompress.compressAndGetFile(
              pickedFilePath, outputPath, quality: percentage.toInt())
          as Future<File>);
      pickedFilePath = compressedFile.path;
    }

    switch (imageView) {
      case ImageView.FRONT:
        setState(() {
          _frontImage = File(pickedFilePath);
        });
        break;
      case ImageView.BACK:
        setState(() {
          _backImage = File(pickedFilePath);
        });
        break;
      case ImageView.LEFT:
        setState(() {
          _leftImage = File(pickedFilePath);
        });
        break;
      case ImageView.RIGHT:
        setState(() {
          _rightImage = File(pickedFilePath);
        });
        break;
    }
  }

  /// Function to pick image from phone photo gallery
  Future getImageFromGallery(ImageView? imageView) async {
    final pickedFile = await (picker.getImage(source: ImageSource.gallery)
        as Future<PickedFile>);

    String pickedFilePath = pickedFile.path;

    /// TODO: readAsBytes throws an error if operation fails
    /// Getting the byte of the image
    final pickedFileByte = await pickedFile.readAsBytes();

    /// Extracting the size of the image
    int imageSize = pickedFileByte.lengthInBytes;

    /// Setting the desired file size
    int targetSize = 1024 * 1024 * 5;

    /// Getting the percentage that the image will need t
    double percentage = (targetSize / imageSize) * 100;

    /// This method takes a passed image path and creates a temporary path
    /// to be used for image compression
    String getCompressedPath(String imagePath) {
      int? extIndex;
      String newPath;

      for (int i = imagePath.length - 1; i > 0; i--) {
        if (imagePath[i] == ".") {
          extIndex = i;
          break;
        }
      }

      String extensionType = imagePath.substring(extIndex!, imagePath.length);
      String partialPath = imagePath.substring(0, extIndex);

      newPath = "${partialPath}_out$extensionType";

      return newPath;
    }

    if (imageSize > targetSize) {
      String outputPath = getCompressedPath(pickedFilePath);
      final compressedFile = await (FlutterImageCompress.compressAndGetFile(
              pickedFilePath, outputPath, quality: percentage.toInt())
          as Future<File>);
      pickedFilePath = compressedFile.path;
    }

    switch (imageView) {
      case ImageView.FRONT:
        setState(() {
          _frontImage = File(pickedFilePath);
        });
        break;
      case ImageView.BACK:
        setState(() {
          _backImage = File(pickedFilePath);
        });
        break;
      case ImageView.LEFT:
        setState(() {
          _leftImage = File(pickedFilePath);
        });
        break;
      case ImageView.RIGHT:
        setState(() {
          _rightImage = File(pickedFilePath);
        });
        break;
    }
  }

  /// Function that opens either gallery or camera based on user's choice
  ///
  /// NOTE: For gallery [getImageFromGallery] && For camera [getImageFromCamera]
  Future<void> imageOptions(ImageView? imageView) async {
    switch (await showDialog<GalleryOrCamera>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Choose Location',
                style: GoogleFonts.rajdhani(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, GalleryOrCamera.CAMERA);
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          Text(
                            'Camera',
                            style: GoogleFonts.rajdhani(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, GalleryOrCamera.GALLERY);
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.photo),
                          Text(
                            'Photo',
                            style: GoogleFonts.rajdhani(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        })) {
      case GalleryOrCamera.CAMERA:
        getImageFromCamera(imageView);
        break;
      case GalleryOrCamera.GALLERY:
        getImageFromGallery(imageView);
        break;
    }
  }

  /// Error toast message when any sides of the image is null
  void showToastMessage() {
    Fluttertoast.showToast(
      msg: 'Please upload all sides of the image',
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  /// Success message for product upload
  void showSuccessMessage() {
    Fluttertoast.showToast(
      msg: 'Successful!',
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      textColor: Colors.green,
      backgroundColor: Colors.white,
    );
  }

  /// Function to validate user has selected the images required and then uploads data to the database
  void validateAndUploadProduct(ProgressDialog pd) async {
    if (_frontImage == null ||
        _backImage == null ||
        _leftImage == null ||
        _rightImage == null) {
      showToastMessage();
    } else {
      await pd.show(
        max: 100,
        msg: "Preparing",
        borderRadius: 8.0,
        elevation: 10.0,
        msqFontWeight: FontWeight.w600,
        msgColor: Colors.black,
        msgFontSize: 18.sp,
      );
      _productImages.add(_frontImage);
      _productImages.add(_backImage);
      _productImages.add(_leftImage);
      _productImages.add(_rightImage);

      print('Pictures added to list');

      try {
        MarketStorageService marketStorageService =
            MarketStorageService(userId: _currentUser!.uid);

        MarketDatabaseService marketDatabaseService =
            MarketDatabaseService(userId: _currentUser!.uid);

        /// Generating a unique code to link all the variations together
        String commonId = uuid.v4();

        pd.update(
          value: 100,
          msg: "Uploading images...",
          // progressWidget: Container(
          //     padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          // maxProgress: 100.0,
        );

        /// Uploading product images to FireStore Storage
        ///
        /// This function will return a List<String> of the image urls
        List<String> productImageStrings =
            await marketStorageService.uploadProductImages(_productImages);

        /// A List<String> of search keywords will be stored here
        ///
        /// NOTE: Refer to the [extractClothSearchKeyWords]
        List<String> searchKeyWords = extractClothSearchKeyWords(
          productCategory: MarketGlobalVariables.productCategory!,
          productName: MarketGlobalVariables.productName!,
          clothMaterial: MarketGlobalVariables.clothMaterial!,
          productBrand: MarketGlobalVariables.productBrand!,
          manufacturer: MarketGlobalVariables.manufacturer!,
          subCategory: MarketGlobalVariables.clothDepartment!,
          productCondition: MarketGlobalVariables.productCondition,
        );

        print('cloth model initialized');

        pd.update(
          value: 100,
          msg: "Finishing up...",
        );

        String productCondition;

        if (MarketGlobalVariables.productCondition == "new product") {
          productCondition = "newProducts";
        } else {
          productCondition = "usedProducts";
        }

        DocumentReference baseModelDocRef = FirebaseFirestore.instance
            .collection("stores")
            .doc(_currentUser!.uid)
            .collection("userStore")
            .doc(MarketGlobalVariables.productCategory!.toLowerCase())
            .collection(productCondition)
            .doc();

        DocumentReference variationDocRef = FirebaseFirestore.instance
            .collection('stores')
            .doc(_currentUser!.uid)

            /// TODO: Get the stores name of the logged in user
            .collection('userStore')
            .doc(MarketGlobalVariables.productCategory!.toLowerCase())
            .collection(productCondition)
            .doc(baseModelDocRef.id)
            .collection('variations')
            .doc();

        /// TODO: Use the [ProductHomeDetailModel] and to replace the [ProductDefaultModel] and delete the later one

        switch (MarketGlobalVariables.productCategory) {
          case "Clothes":

            /// TODO: Loop through the list of variation sizes and add to map, setting the values as "true"
            Map<String, bool> clothSizes;
            clothSizes = {
              MarketGlobalVariables.clothSize!: true,
            };
            clothBaseModel = ClothBaseModel(
              id: _currentUser!.uid,
              cmId: commonId,
              docId: baseModelDocRef.id,
              prN: MarketGlobalVariables.productName,
              cond: MarketGlobalVariables.productCondition,
              prC: MarketGlobalVariables.productCategory,
              prImg: productImageStrings,
              rtC: 0,
              rate: 0,
              rvC: 0,
              price: MarketGlobalVariables.productPrice,
              sdCnt: 0,
              sWords: searchKeyWords,
              cSize: clothSizes,
              subC: MarketGlobalVariables.clothDepartment,
            );

            // productHomeDetailModel = ProductHomeDetailModel(
            //   id: _currentUser.uid,
            //   cmId: commonId,
            //   docId: baseModelDocRef.id,
            //   prN: MarketGlobalVariables.productName,
            //   cond: MarketGlobalVariables.productCondition,
            //   prC: MarketGlobalVariables.productCategory,
            //   prImg: productImageStrings,
            //   rtC: 0,
            //   rate: 0,
            //   rvC: 0,
            //   price: MarketGlobalVariables.productPrice,
            //   sdCnt: 0,
            //   sWords: searchKeyWords,
            // );

            clothProductListingModel = ClothProductListingModel(
              id: _currentUser!.uid,
              docId: variationDocRef.id,
              cmId: commonId,
              sku: uuid.v4(),
              isFirst: true,
              stock: MarketGlobalVariables.productQuantity,
              cond: MarketGlobalVariables.productCondition,
              prC: MarketGlobalVariables.productCategory,
              subC: MarketGlobalVariables.clothDepartment,
              cSize: MarketGlobalVariables.clothSize,
              cCol: MarketGlobalVariables.clothColor,
              mat: MarketGlobalVariables.clothMaterial,
              qty: MarketGlobalVariables.productQuantity,
              pIdTp: MarketGlobalVariables.productIdType,
              pIdC: MarketGlobalVariables.productIdCode,
              prN: MarketGlobalVariables.productName,
              prB: MarketGlobalVariables.productBrand,
              mfac: MarketGlobalVariables.manufacturer,
              price: MarketGlobalVariables.productPrice,
              pDes: MarketGlobalVariables.productDescription,
              ts: DateTime.now().millisecondsSinceEpoch,
              prImg: productImageStrings,
              sdCnt: 0,
            );

            await marketDatabaseService.uploadClothBaseFields(
                baseModelDocRef, clothBaseModel);

            await marketDatabaseService.uploadClothProductListing(
                variationDocRef, clothProductListingModel);
            break;
        }

        pd.close();

        Navigator.pop(context);

        // Navigator.of(context).pushReplacementNamed(MarketHome.id);

        showSuccessMessage();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pd = ProgressDialog(
      context: context,
    );

    // pd.style(
    //     message: 'Process started...',
    //     borderRadius: 8.0,
    //     backgroundColor: Colors.white,
    //     progressWidget: CircularProgressIndicator(),
    //     elevation: 10.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     messageTextStyle: marketProgressDialogTextStyle);

    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.only(top: 24.0),
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 8.0,
            children: <Widget>[
              CustomImagePickerBox(
                onTap: () {
                  setState(() {
                    imageView = ImageView.FRONT;
                    imageOptions(imageView);
                  });
                },
                widget: _frontImage == null
                    ? ImageAddIconAndText(
                        buttonText: 'Upload image front',
                      )
                    : Image.file(
                        _frontImage!,
                        fit: BoxFit.cover,
                      ),
              ),
              CustomImagePickerBox(
                onTap: () {
                  setState(() {
                    imageView = ImageView.BACK;
                    imageOptions(imageView);
                  });
                },
                widget: _backImage == null
                    ? ImageAddIconAndText(
                        buttonText: 'Upload image back',
                      )
                    : Image.file(
                        _backImage!,
                        fit: BoxFit.cover,
                      ),
              ),
              CustomImagePickerBox(
                onTap: () {
                  setState(() {
                    imageView = ImageView.LEFT;
                    imageOptions(imageView);
                  });
                },
                widget: _leftImage == null
                    ? ImageAddIconAndText(
                        buttonText: 'Upload image left',
                      )
                    : Image.file(
                        _leftImage!,
                        fit: BoxFit.cover,
                      ),
              ),
              CustomImagePickerBox(
                onTap: () {
                  setState(() {
                    imageView = ImageView.RIGHT;
                    imageOptions(imageView);
                  });
                },
                widget: _rightImage == null
                    ? ImageAddIconAndText(
                        buttonText: 'Upload image right',
                      )
                    : Image.file(
                        _rightImage!,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ProductListingNextBackButton(
              buttonName: 'Back',
              onTap: () {
                widget.tabController!.animateTo(2,
                    duration: Duration(
                      microseconds: 300,
                    ),
                    curve: Curves.easeIn);
              },
            ),
            ProductListingNextBackButton(
              buttonName: 'Submit',
              onTap: () {
                validateAndUploadProduct(pd);
                print('Submit clicked!');
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
