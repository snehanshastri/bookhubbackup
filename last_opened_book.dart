import 'package:flutter/material.dart';
import 'package:bookhubapp/widgets/reading_book.dart';

import 'package:bookhubapp/widgets/book_cover_3d.dart';

class LastOpenedBook extends StatelessWidget {
  const LastOpenedBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReadingBook(
                          pdfPath: "assets/harry_potter.pdf",
                        )),
              );
            },
            child: const BookCover3D(
              imageUrl:
                  "https://m.media-amazon.com/images/I/418HLIXlxCL._SY291_BO1,204,203,200_QL40_FMwebp_.jpg",
            ),
          ),
        ),
      ],
    );
  }
}