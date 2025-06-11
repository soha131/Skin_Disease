import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'cubit/skin_cubit.dart';
import 'cubit/skin_state.dart';
class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});
  @override
  _UploadFileScreenState createState() => _UploadFileScreenState();
}
class _UploadFileScreenState extends State<UploadFileScreen> {
  static const double paddingSize = 20.0;
  static const double imageContainerHeightFactor = 0.25;
  static const Color buttonColor = Color(0xff89A8B2);
  File? _filePath;
  void _showResultModal(BuildContext context, String description, String predictedClass) {
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Predicted Condition:".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0993a8),
                ),
              ),
              Text(
                predictedClass,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Description:".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:Color(0xff0993a8),
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                BlocBuilder<SkinPredictionCubit, SkinPredictionState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.all(paddingSize),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      final XFile? photo = await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                      );

                                      if (photo != null) {
                                        setState(() {
                                          _filePath = File(photo.path);
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Take a photo".tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff3C3D37),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  TextButton(
                                    onPressed: () async {
                                      final XFile? photo = await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                      );

                                      if (photo != null) {
                                        setState(() {
                                          _filePath = File(photo.path);
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Choose from gallery".tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff3C3D37),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .80,
                        height: screenHeight * imageContainerHeightFactor,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _filePath == null
                            ? Semantics(
                          label: "Drag or Click to choose an Image".tr(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              Icon(
                                Icons.cloud_upload,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Drag or Click to choose an Image".tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                            : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(19),
                              child: Image.file(
                                _filePath!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _filePath = null;
                                  });
                                  BlocProvider.of<SkinPredictionCubit>(context)
                                      .emit(SkinPredictionInitial());
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 16,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () {
                    if (_filePath != null) {
                      BlocProvider.of<SkinPredictionCubit>(context).dates(_filePath!, context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:  Text(
                    "RESULT".tr(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                BlocListener<SkinPredictionCubit, SkinPredictionState>(
                  listener: (context, state) async {
                    if (state is SkinPredictionSuccess) {
                      final desc = state.prediction.description;
                      final predicted = state.prediction.predictedClass;
                      _showResultModal(context, desc, predicted);

                    } else if (state is SkinPredictionError) {
                      _showResultModal(context, 'Error', 'Error');
                    }
                  },
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Locale newLocale = context.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
          context.setLocale(newLocale);

        },
        backgroundColor: Colors.white,
        child: Icon(Icons.language, color: Color(0xff385e61)),
      ),
    );
  }
}
