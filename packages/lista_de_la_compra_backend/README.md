# Backend

The frontend backend separation is ment to allow 2 diferent frontends to share the backend code. This backend is used by the Android app and by the headless server.

If the database schema changes remember to run `dart run build_runner build` on this folder.