import 'package:bookhubapp/models/audio_book.dart';
import 'package:bookhubapp/models/books.dart';
import 'package:uuid/uuid.dart';

List<Book> getBooksByType(Category category) {
  List<Book> allBooks = getAllBooks();
  return allBooks.where((book) => book.category == category).toList();
}

List<Book> getBooksByPurchased() {
  List<Book> allBooks = getAllBooks();
  return allBooks.where((book) => book.isPurchased == true).toList();
}

List<Book> getBooksByFree() {
  List<Book> allBooks = getAllBooks();
  return allBooks.where((book) => book.isFree == true).toList();
}

List<Book> getBooksByOpenPage(int page) {
  List<Book> allBooks = getAllBooks();
  return allBooks.where((book) => book.lastOpenPage >= page).toList();
}

List<Book> getDiscountedBooks() {
  List<Book> allBooks = getAllBooks();
  return allBooks.where((book) => book.isDiscounted).toList();
}

List<Book> getPopularBooks() {
  List<Book> allBooks = getAllBooks();
  return allBooks.where((book) => book.isPopular).toList();
}

List<AudioBook> getAudioBooks() 
{
  List<AudioBook> allBooks=getAllAudioBooks();
  return allBooks.toList();

}

List<Book> getAllBooks()
{
  return [
    Book(
      title: 'Pride and Prejudice',
      category: Category.artAndLit,
      isbn: '9780140174922',
      price: 130,
      isFree: false,
      isPurchased: false,
      description:
      'A story of love and societal expectations in the 19th century England.',
  rating: 4.5,
  yearRelease: 1813,
  pages: 432,
      authorName: 'Jane Austen',
      imageUrl:
          'https://th.bing.com/th/id/R.c1c6633e41f81590f94188bfda47f1c4?rik=Y8yYxcTO5JDqfg&riu=http%3a%2f%2fd28hgpri8am2if.cloudfront.net%2fbook_images%2fonix%2fcvr9781471134746%2fpride-and-prejudice-9781471134746_hr.jpg&ehk=x2q%2fXHpsXqzUEAXbe4Bq%2f7uW8D%2fDjubqcxy5Kr9N93g%3d&risl=&pid=ImgRaw&r=0',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Fiction',
      coverImage:
          'https://th.bing.com/th/id/R.c1c6633e41f81590f94188bfda47f1c4?rik=Y8yYxcTO5JDqfg&riu=http%3a%2f%2fd28hgpri8am2if.cloudfront.net%2fbook_images%2fonix%2fcvr9781471134746%2fpride-and-prejudice-9781471134746_hr.jpg&ehk=x2q%2fXHpsXqzUEAXbe4Bq%2f7uW8D%2fDjubqcxy5Kr9N93g%3d&risl=&pid=ImgRaw&r=0',
      isDiscounted: false,
      isPopular: true,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/prideandprejudice.pdf"
    ),

       Book(
      title: 'Moby Dick',
     category: Category.adventure,
  isbn: '9781503280786',
  price: 279,
  isFree: false,
  isPurchased: false,
  description:
      'A thrilling saga of Captain Ahab’s obsessive quest to seek revenge on the white whale, Moby Dick.',
  rating: 4.3,
  yearRelease: 1851,
  pages: 635,
  authorName: 'Herman Melville',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781471137235/moby-dick-9781471137235.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Adventure',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781471137235/moby-dick-9781471137235.jpg',
      isDiscounted: false,
      isPopular: true,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/mobydick.pdf"
    ),

       Book(
      title: 'The Adventures of Sherlock Holmes',
  category: Category.mystery,
  isbn: '9781593080361',
  price: 151,
  isFree: false,
  isPurchased: false,
  description:
      'A collection of twelve stories featuring the famous detective Sherlock Holmes.',
  rating: 4.7,
  yearRelease: 1892,
  pages: 307,
  authorName: 'Arthur Conan Doyle',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781607102113/the-adventures-of-sherlock-holmes-and-other-stories-9781607102113.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Mystery',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781607102113/the-adventures-of-sherlock-holmes-and-other-stories-9781607102113.jpg',
      isDiscounted: false,
      isPopular: true,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/arthur-conan-doyle_adventures-of-sherlock-holmes.pdf"
    ),

       Book(
      title: 'Frankenstein',
  category: Category.fiction,
  isbn: '9780486282114',
  price: 165,
  isFree: false,
  isPurchased: false,
  description:
      'A story about the scientist Victor Frankenstein who creates a grotesque creature in an unorthodox scientific experiment.',
  rating: 4.2,
  yearRelease: 1818,
  pages: 280,
  authorName: 'Mary Shelley',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781607109457/frankenstein-9781607109457_lg.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Fiction',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781607109457/frankenstein-9781607109457_lg.jpg',
      isDiscounted: false,
      isPopular: true,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/frankenstein.pdf"
    ),

    Book(
      title: 'Alice\'s Adventures in Wonderland',
  category: Category.fantasy,
  isbn: '9781447279990',
  price: 119,
  isFree: false,
  isPurchased: false,
  description:
      'A whimsical tale of a young girl named Alice who falls through a rabbit hole into a fantastical world.',
  rating: 4.5,
  yearRelease: 1865,
  pages: 200,
  authorName: 'Lewis Carroll',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781665925778/alices-adventures-in-wonderland-9781665925778.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Fantasy',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781665925778/alices-adventures-in-wonderland-9781665925778.jpg',
      isDiscounted: false,
      isPopular: true,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/Alices Adventures in Wonderland.pdf"
    ),

    Book(
     title: 'Treasure Island',
  category: Category.adventure,
  isbn: '9780141321004',
  price: 129,
  isFree: false,
  isPurchased: false,
  description:
      'A tale of pirates and buried gold, featuring one-legged seafaring men and daring adventures on the high seas.',
  rating: 4.6,
  yearRelease: 1883,
  pages: 240,
  authorName: 'Robert Louis Stevenson',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/cvr9781442474444_9781442474444_lg.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Adventure',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/cvr9781442474444_9781442474444_lg.jpg',
      isDiscounted: false,
      isPopular: true,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/treasureisland.pdf"
    ),

    Book(
      title: 'The Adventures of Huckleberry Finn',
  category: Category.adventure,
  isbn: '9780486280615',
  price: 140,
  isFree: false,
  isPurchased: false,
  description:
      'The story of Huck’s escape from his brutal father and the relationship that grows between him and Jim, the slave who is fleeing from an even more brutal oppression.',
  rating: 4.2,
  yearRelease: 1884,
  pages: 366,
  authorName: 'Mark Twain',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781607105503/adventures-of-huckleberry-finn-9781607105503.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Adventure',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781607105503/adventures-of-huckleberry-finn-9781607105503.jpg',
      isDiscounted: false,
      isPopular: true,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/the-adventures-of-huckleberry-finn.pdf"
    ),

    //discounted books
    Book(
      title: 'The Art of War',
  category: Category.nonFiction,
  isbn: '9781599869772',
  price: 270,
  isFree: false,
  isPurchased: false,
  description:
      'An ancient Chinese military treatise attributed to Sun Tzu, a high-ranking military general, strategist, and tactician.',
  rating: 4.6,
  yearRelease: -500,
  pages: 60,
  authorName: 'Sun Tzu',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781605500300/sun-tzu-the-art-of-war-for-managers-9781605500300_lg.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Non Fiction',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781605500300/sun-tzu-the-art-of-war-for-managers-9781605500300_lg.jpg',
      isDiscounted: true ,
      isPopular: false,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/ArtOfWar.pdf"
    ),

    Book(
      title: 'Little Women',
  category: Category.classic,
  isbn: '9780140430332',
  price: 106,
  isFree: false,
  isPurchased: false,
  description:
      'A coming-of-age novel following the lives of four sisters—Meg, Jo, Beth, and Amy March—detailing their passage from childhood to womanhood.',
  rating: 4.5,
  yearRelease: 1868,
  pages: 759,
  authorName: 'Louisa May Alcott',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781534462205/little-women-9781534462205_lg.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Classic',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781534462205/little-women-9781534462205_lg.jpg',
      isDiscounted: true,
      isPopular: false,
      pdfPath:"gs://bookhubapp-ca543.appspot.com/books/little-women.pdf"
    ),

    Book(
      title: 'The Time Machine',
  category: Category.scienceFiction,
  isbn: '9780553213515',
  price: 79,
  isFree: false,
  isPurchased: false,
  description:
      'A science fiction novella by H. G. Wells, exploring time travel and its implications.',
  rating: 4.3,
  yearRelease: 1895,
  pages: 118,
  authorName: 'H. G. Wells',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781439117163/the-time-machine-9781439117163_lg.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Science Fiction',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781439117163/the-time-machine-9781439117163_lg.jpg',
      isDiscounted: true,
      isPopular: false,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/timemachine.pdf"
    ),

    Book(
      title: 'A Tale of Two Cities',
  category: Category.classic,
  isbn: '9780141439600',
  price: 109,
  isFree: false,
  isPurchased: false,
  description:
      'A historical novel by Charles Dickens, set in London and Paris before and during the French Revolution.',
  rating: 4.4,
  yearRelease: 1859,
  pages: 489,
  authorName: 'Charles Dickens',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781627933797/a-tale-of-two-cities-9781627933797_lg.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Classic',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781627933797/a-tale-of-two-cities-9781627933797_lg.jpg',
      isDiscounted: true,
      isPopular: false,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/a-tale-of-two-cities.pdf"
    ),

    Book(
       title: 'The Call of the Wild',
  category: Category.adventure,
  isbn: '9780486264721',
  price: 109,
  isFree: false,
  isPurchased: false,
  description:
      'A short adventure novel about a sled dog named Buck, set during the Klondike Gold Rush.',
  rating: 4.5,
  yearRelease: 1903,
  pages: 172,
  authorName: 'Jack London',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781625580702/the-call-of-the-wild-9781625580702_lg.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Adventure',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781625580702/the-call-of-the-wild-9781625580702_lg.jpg',
      isDiscounted: true,
      isPopular: false,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/Call of Wild.pdf"
    ),

    Book(
       title: 'The Jungle Book',
  category: Category.children,
  isbn: '9780486129427',
  price: 109,
  isFree: false,
  isPurchased: false,
  description:
      'A collection of stories featuring Mowgli, a boy raised by wolves in the jungle.',
  rating: 4.4,
  yearRelease: 1894,
  pages: 212,
  authorName: 'Rudyard Kipling',
      imageUrl:
          'https://th.bing.com/th?id=OIP.3uenJvGgIFIMpFmPzwpzkQHaJp&w=218&h=285&c=8&rs=1&qlt=90&o=6&dpr=1.5&pid=3.1&rm=2',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Children',
      coverImage:
          'https://th.bing.com/th?id=OIP.3uenJvGgIFIMpFmPzwpzkQHaJp&w=218&h=285&c=8&rs=1&qlt=90&o=6&dpr=1.5&pid=3.1&rm=2',
      isDiscounted: true,
      isPopular: false,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/the-jungle-book.pdf"
    ),

    Book(
       title: 'Wuthering Heights',
  category: Category.classic,
  isbn: '9781853260018',
  price: 119,
  isFree: false,
  isPurchased: false,
  description:
      'A novel by Emily Brontë, exploring the passionate and destructive love between Heathcliff and Catherine Earnshaw.',
  rating: 4.3,
  yearRelease: 1847,
  pages: 354,
  authorName: 'Emily Brontë',
      imageUrl:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781471137266/wuthering-heights-9781471137266.jpg',
      lastOpenPage: 50,
      totalXP: 100,
      genre: 'Fiction',
      coverImage:
          'https://d28hgpri8am2if.cloudfront.net/book_images/onix/cvr9781471137266/wuthering-heights-9781471137266.jpg',
      isDiscounted: true,
      isPopular: false,
      pdfPath: "gs://bookhubapp-ca543.appspot.com/books/wuthering-heights.pdf"
    ),
    // Add more books as per your requirements
  ];
}

List<AudioBook> getAllAudioBooks() {
  const uuid = Uuid();
  return [
    AudioBook(
      id: uuid.v4(),
      title: "Lady Susan",
      coverImage: "https://th.bing.com/th/id/OIP.AO6jvPTfi2cddiA8egvLkgHaHa?w=191&h=191&c=7&r=0&o=5&dpr=1.5&pid=1.7",
      genre: "Fiction",
      description: "A novella featuring the cunning and manipulative Lady Susan Vernon, who navigates society to secure advantageous marriages for herself and her daughter.",
      rating: 4.8,
      price: 119,
      audioPath:"gs://bookhubapp-ca543.appspot.com/audiobooks/ladysusan/ladysusan_1_austen_64kb.mp3"
    ),
    AudioBook(
      id: uuid.v4(),
      title: "Oliver Twist",
      coverImage: "https://th.bing.com/th/id/OIP.ov9eeAIFJuXIJu-zoYTJjwHaHa?w=188&h=188&c=7&r=0&o=5&dpr=1.5&pid=1.7",
      genre: "Fiction",
      description: "A novel depicting the life of an orphan boy who navigates the harsh realities of Victorian London, encountering both kindness and cruelty.",
      rating: 4.7,
      price: 119,
      audioPath:"gs://bookhubapp-ca543.appspot.com/audiobooks/oliver twist/dickens_oliver_twist_01_64kb.mp3"
    ),
    AudioBook(
      id: uuid.v4(),
      title: "The Curious Case of Benjamin Button",
      coverImage: "https://th.bing.com/th/id/OIP.Gj7Hv5VjGPzP_XAT3fM2wQHaJM?w=157&h=195&c=7&r=0&o=5&dpr=1.5&pid=1.7",
      genre: "Fantasy",
      description: "A fantastical tale of a man who ages backward, experiencing life in reverse, while those around him age normally.",
      rating: 4.6,
      price: 119,
      audioPath:"gs://bookhubapp-ca543.appspot.com/audiobooks/the curious case of benjamin button/benjamanbutton_01_fitzgerald_64kb.mp3"
    ),
  ];
}
