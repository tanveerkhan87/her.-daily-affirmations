
import 'package:animate_do/animate_do.dart'; // Animation effects like ZoomIn, FadeInUp
import 'package:flutter/material.dart'; // Core Flutter UI
import 'package:camera/camera.dart'; // Camera functionality
import 'package:google_fonts/google_fonts.dart'; // Custom Google fonts

// Main Widget (Screen) for Mind's Eye feature
class MindsEye extends StatefulWidget {
  const MindsEye({super.key});

  @override
  State<MindsEye> createState() => _MindsEyeState();
}

class _MindsEyeState extends State<MindsEye> {
  late CameraController _cameraController; // Controls camera input
  late Future<void> _initializeControllerFuture; // To manage async camera setup
  bool _isCameraInitialized = false; // Tracks if camera is ready

  int _currentQuoteIndex = 0; // Current index for quote display

  // List of inspirational quotes shown below the camera
  final List<String> _quotes = [
    "The future belongs to those who believe in the beauty of their dreams.",
    "The only way out of the labyrinth of suffering is to forgive",
    "An eye for an eye only ends up making the whole world blind.",
    "Love is composed of a single soul inhabiting two bodies.",
    "Keep your face to the sunshine and you cannot see a shadow.",
    "The soul is dyed the color of its thoughts.",
    "A pessimist sees the difficulty in every opportunity; an optimist sees the opportunity in every difficulty.",
    "The power of imagination makes us infinite.",
    "In the end, we will remember not the words of our enemies, but the silence of our friends.",
    "The journey of a thousand miles begins with one step.",
    "The greatest glory in living lies not in never falling, but in rising every time we fall.",
    "The mind is everything. What you think you become.",
    "To love and be loved is to feel the sun from both sides.",
    "You have within you right now, everything you need to deal with whatever the world can throw at you.",
    "Dream big and dare to fail.",
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Set up camera when screen opens
  }

  // Initialize front camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras(); // Get available cameras
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    // Setup controller for front camera
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Initialize the controller and update state once done
    _initializeControllerFuture = _cameraController.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }).catchError((e) {
      // Handle initialization errors if any
    });
  }

  @override
  void dispose() {
    _cameraController.dispose(); // Release camera when screen is closed
    super.dispose();
  }

  // Go to next quote in the list
  void _showNextQuote() {
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
    });
  }

  // Go to previous quote in the list
  void _showPreviousQuote() {
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex - 1 + _quotes.length) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color appBarBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.white;
    final Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mind's Eye",
          style: GoogleFonts.montserratAlternates(
            color: textColor,
            fontSize: 22,
          ),
        ),
        backgroundColor: appBarBackgroundColor,
        elevation: 4,
        iconTheme: IconThemeData(
          color: textColor,
        ),
      ),

      // Only show UI after camera is initialized
      body: _isCameraInitialized
          ? Column(
        children: [
          // Camera display in a pink border with ZoomIn animation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ZoomIn(
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.pink,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CameraPreview(_cameraController), // Camera feed
                ),
              ),
            ),
          ),

          // Header message below camera
          Text(
            'Watch yourself and see the quote',
            style: GoogleFonts.montserratAlternates(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),

          SizedBox(height: 20),

          // Quote display section with animated slide up
          Expanded(
            child: FadeInUp(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(80),
                  ),
                ),
                child: Column(
                  children: [
                    // Centered quote text
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            _quotes[_currentQuoteIndex],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Navigation buttons (Back and Next)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 38),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.pink),
                              backgroundColor: Colors.pink.shade300,
                            ),
                            onPressed: _showPreviousQuote,
                            child: Text('Back'),
                          ),

                          // Next button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.pink),
                              backgroundColor: Colors.pink.shade300,
                            ),
                            onPressed: _showNextQuote,
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : null, // Don't build body if camera is not initialized
    );
  }
}
