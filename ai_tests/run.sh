
rm ./testing_*

    cd ../flutterfiles
    flutter run --release --dart-define=TEST_MODEL_METADATA=true
    mv ../flutterfiles/testing_* ../ai_tests/

