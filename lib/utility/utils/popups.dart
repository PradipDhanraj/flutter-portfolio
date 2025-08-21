import 'package:flutter/material.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/widgets/qr_code_image.dart';

class Popups {
  Popups._();

  static Future<bool?> showConfirmationPopup(
    String title,
    String message,
  ) async {
    return showDialog<bool>(
      context: DI.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSizes.large,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSizes.medium,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showSendMessageBottomDialog(
    BuildContext context,
    Event event, {
    void Function(String title, String description)? onSend,
  }) async {
    final titleController = TextEditingController(
      text: event.title.toUpperCase(),
    );
    final descriptionController = TextEditingController();

    Widget textField({
      required TextEditingController controller,
      required String hintText,
      required TextStyle hintStyle,
    }) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: hintStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        style: const TextStyle(color: Colors.black),
      );
    }

    showModalBottomSheet(
      isDismissible: true,
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.black,
      elevation: 10,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 300),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSizes.large,
                  ),
                ),
                SizedBox(height: 20),
                textField(
                  controller: titleController,
                  hintText: 'Notification Title',
                  hintStyle: const TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 20),
                textField(
                  controller: descriptionController,
                  hintText: 'Add message here',
                  hintStyle: const TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (onSend != null) {
                          onSend(
                            titleController.text,
                            descriptionController.text,
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Broadcast',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  static Future<void> showQRCodePopup(BuildContext context, String data) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      barrierDismissible: true,
      builder: (context) {
        return Center(child: QRWidget(data));
      },
    );
  }
}
