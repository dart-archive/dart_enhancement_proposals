Attendees: [Bob][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## [Package spec]

[package spec]: https://github.com/dart-lang/dart_enhancement_proposals/issues/5

### Syntax

[Lasse][] updated the proposal based on some discussions he had with [Ivan][].
Ivan signed off on a simple key/value mapping. No YAML, no Dart syntax, no Java
property file.

[lasse]: https://github.com/lrhn
[ivan]: https://github.com/iposva-google

Also Lasse fixed the reference to the spec, which was incorrect.

The feeling on the committee is that a dumb key/value mapping&mdash;think an
INI file&mdash;isn't satisfying. It doesn't give us any wiggle room for future
extensions. We have some internal users who may want this extended in the
future for their needs and this doesn't help there.

Gilad suggested we could put a version number at the top of the file, but that
doesn't feel much better. We could just use a different file name at that
point.

YAML is nice in that we use it for other things, but it isn't trivial to parse.
Kasper wondered if Ivan would accept something more like a named Dart map
literal. According to Gilad, the VM isn't set up to reuse that part of the
parser right now.

We'd love it to be Dart syntax. It gives us a reasonable file extension,
editors can syntax highlight it, etc. Maybe we could just specify a very
restricted grammar but using the same scanner.

It would be a strict subset of Dart syntax. Reusing the lexical grammar gives
us most of the value: it takes care of encoding, whitespace, comments,
escaping, etc.

Writing a new parser for a limited set of tokens should be pretty easy. This
would be easier to extend, and easier to specify.

*[I][bob] will update the [relevant bug][syntax bug] with our suggestion.*

[syntax bug]: https://github.com/lrhn/dep-pkgspec/issues/1

We still aren't sure what the long-term picture for the file is. Would we
eventually want to be able to put other constants in there that become part of
the program's constant environment? We don't need to answer this, but it's
interesting to consider.

Either way, if this is a file that other tools and the ecosystem will build
around, it should be stable and extensible. We're thinking a constant with a
named value. Something like:

```dart
const packages = {
  "args": "../../args",
  "unittest": "/Users/bob/.pub-cache/hosted/pub.dartlang.org/unittest/lib/"
};
```

This makes it a valid Dart library. Other libraries could even possibly import
it.

### [Walking up directories][dirs]

[dirs]: https://github.com/lrhn/dep-pkgspec/issues/3

Ivan says walking up directories to look for a package spec doesn't work for
HTTP entrypoints. We say fine, only do it for file URLs.

The command line VM has to do this or package specs aren't a useful feature.
The initial motivation is to eliminate symlinks. If we don't walk up
directories, then we can't eliminate the symlinks in package subdirectories.

However, this behavior doesn't necessarily have to be in the *language spec*.
It's just that all of the teams and tools need to agree to implement it. From
the spec's perspective we can just say this behavior is implementation
dependent.

Pulling this behavior out of the spec may be good for people like the [Sky][]
folks who have their own Dart embedder. This behavior may not make sense for
them and we don't want them to be shoehorned into it.

[sky]: https://github.com/domokit/sky_sdk/

Our thought then is to pull this out of the spec but have something like an
annex that describes it and that the tools all agree to follow. This is similar
to the core libraries in many ways: they aren't specced but dart2js, the
analyzer, and the VM agree to be compatible.

We *do* want describing and agreeing on this behavior to be part of the *DEP*,
though. The agreement won't end up in the spec, but it still needs to happen.

### File name

I noted briefly that "pkg" isn't used anywhere else in our tooling, so
"package" or "packages" probably makes more sense.

## Next week

Kasper will invite Ivan and Lasse just in case we don't get everything resolved
on the bug tracker by next week's meeting.

The [generic methods proposal][] is a complex beast, so we're still chewing on
that.

The stuff around [configuration][] is still pretty unformed and isn't ready for
the committee meeting yet. We'll keep working on that outside of the meeting
for now.

[generic methods proposal]: https://github.com/dart-lang/dart_enhancement_proposals/issues/22
* [configuration](https://github.com/dart-lang/dart_enhancement_proposals/issues/6)
