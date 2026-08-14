/// A single quote category with its metadata and list of quotes.
class QuoteCategory {
  final String id;
  final String title;
  final String image;
  final List<String> quotes;

  const QuoteCategory({
    required this.id,
    required this.title,
    required this.image,
    required this.quotes,
  });
}
