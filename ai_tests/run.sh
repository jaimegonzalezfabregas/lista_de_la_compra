cd ../flutterfiles
# flutter run --release --dart-define=TEST_MODEL_METADATA=true  | { tee /dev/tty | grep CATALOG_TEST_RESULT > ../ai_tests/result.log; }

flutter run --dart-define=TEST_MODEL_METADATA=true | tee ../ai_tests/execution.log

cat ../ai_tests/execution.log | grep CATALOG_TEST_RESULT > ../ai_tests/ai_result.log