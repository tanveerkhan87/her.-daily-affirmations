



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:shared_preferences/shared_preferences.dart';

class HearYourVoiceScreen extends StatefulWidget {
  const HearYourVoiceScreen({super.key});

  @override
  _HearYourVoiceScreenState createState() => _HearYourVoiceScreenState();
}



class _HearYourVoiceScreenState extends State<HearYourVoiceScreen> {
  late RecorderController _recorderController;
  late PlayerController _playerController;
  bool _isRecording = false;
  bool _isPlaying = false;
  List<String> _recordings = [];
  String? _currentFilePath;
  String? _playingFilePath;
  int _currentQuoteIndex = 0;

  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<String> _quotes = [
    "The only way to do great work is to love what you do.",
    "Believe you can and you're halfway there.",
    "Success is not the key to happiness. Happiness is the key to success.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "Do not watch the clock. Do what it does. Keep going."
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadRecordings();
  }

  Future<void> _initControllers() async {
    try {
      _recorderController = RecorderController();
      _playerController = PlayerController();
    } catch (e) {
      _showToast('Error initializing controllers: $e');
    }
  }

  Future<String> _getFilePath() async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory.path}/recording_$timestamp.aac';
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;

    try {
      _currentFilePath = await _getFilePath();
      await _recorderController.record(path: _currentFilePath!);
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      _showToast('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      await _recorderController.stop();
      setState(() {
        _isRecording = false;
        if (_currentFilePath != null) {
          _recordings.add(_currentFilePath!);
          _saveRecordings();
          _currentFilePath = null;
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
          _carouselController.nextPage();
        }
      });
    } catch (e) {
      _showToast('Error stopping recording: $e');
    }
  }

  Future<void> _playRecordedFile(String path) async {
    if (_isPlaying) return;

    try {
      _playerController.dispose();
      _playerController = PlayerController();
      await _playerController.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );


     // await _playerController.startPlayer(finishMode: FinishMode.stop);
      setState(() {
        _isPlaying = true;
        _playingFilePath = path;
      });

      _playerController.onCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _playingFilePath = null;
        });
      });
    } catch (e) {
      _showToast('Error playing file: $e');
    }
  }

  Future<void> _stopPlayer() async {
    try {
      await _playerController.stopPlayer();
      setState(() {
        _isPlaying = false;
        _playingFilePath = null;
      });
    } catch (e) {
      _showToast('Error stopping player: $e');
    }
  }

  Future<void> _deleteRecording(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          _recordings.remove(path);
          _saveRecordings();
          if (_playingFilePath == path) {
            _stopPlayer();
          }
        });
      }
    } catch (e) {
      _showToast('Error deleting file: $e');
    }
  }

  Future<void> _saveRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recordings', _recordings);
  }

  Future<void> _loadRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    final recordings = prefs.getStringList('recordings') ?? [];
    setState(() {
      _recordings = recordings;
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _recorderController.dispose();
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color appBarBackgroundColor =
    theme.brightness == Brightness.dark ? Colors.black : Colors.white;
    final Color textColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Record Quotes",
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CarouselSlider.builder(
                itemCount: _quotes.length,
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentQuoteIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _quotes[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontFamily: 'font1',
                          ),
                        ),
                      ),
                    ),
                  );
                },
                carouselController: _carouselController,
              ),
              SizedBox(height: 20),
              Text(
                "Record your voice according to the quotes to feel their essence.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'font14',
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 90,
                width: MediaQuery.of(context).size.width,
                child: _isRecording || _isPlaying
                    ? AudioWaveforms(
                  waveStyle: WaveStyle(
                    waveColor: Colors.indigo,
                    waveThickness: 5.3,
                  ),
                  size: Size(MediaQuery.of(context).size.width, 100),
                  backgroundColor: Colors.white,
                  recorderController: _recorderController,
                )
                    : Container(
                  color: Colors.blueGrey.shade100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mic_none,
                          size: 50,
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: _isRecording ? null : _startRecording,
                      icon: Icon(Icons.mic),
                      label: Text("Record"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: !_isRecording ? null : _stopRecording,
                      icon: Icon(Icons.stop),
                      label: Text("Stop"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _recordings.length,
                  itemBuilder: (context, index) {
                    final quote = _quotes[index % _quotes.length]; // Display the corresponding quote

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          'Recording ${index + 1}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            quote,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _playingFilePath == _recordings[index] && _isPlaying
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                color: _playingFilePath == _recordings[index] && _isPlaying
                                    ? Colors.red
                                    : Colors.indigo,
                              ),
                              onPressed: () {
                                if (_playingFilePath == _recordings[index] && _isPlaying) {
                                  _stopPlayer();
                                } else {
                                  _playRecordedFile(_recordings[index]);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.pink.shade900,

                              onPressed: () => _deleteRecording(_recordings[index]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}

