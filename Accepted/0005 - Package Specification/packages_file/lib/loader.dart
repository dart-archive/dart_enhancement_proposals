// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Helper library for `packagecfg` that uses `dart:io` to save and load files.
library packagemap.loader;

import "packages_file.dart";
import "dart:io";
import "dart:async";

/// Loads a `.packages` file and parse the content into a [Packages] object.
Future<Packages> loadPackageConfig(File inputFile) {
  Uri fileUri = new Uri.file(inputFile.path);
  return inputFile.readAsString().then((String source) {
    return Packages.parse(source, fileUri);
  });
}

/// Saves a [Packages] object to a `.packages` file.
Future savePackageConfig(File outputFile, Packages packages) {
  // NOT TESTED.
  Uri fileUri = new Uri.file(outputFile.path);
  IOSink output = destination.openWrite();
  packages.write(output, baseUri: fileUri);
  return packages.close();
}
