Attendees: [Bob][], [Florian][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## [Config-specific code][40]

[40]: https://github.com/dart-lang/dart_enhancement_proposals/issues/40

Most of the meeting was discussing this proposal. In particular, how to handle
public types in configuration specific libraries.

There isn't consensus on how important it is to be able to configure types.
Supporting this is necessary if you want to be able extend a
configuration-specific class at runtime. The driving example is the `Element`
class in `dart:html`.

The dart4web team would like to be able to write a platform-independent wrapper
around the DOM that works both on the server (using html5lib) and in the
browser. You could imagine something like:

```dart
// html.dart
export 'html_interfaces.dart'
    if (dart.library.html) 'dart:html'
    if (dart.library.io) 'html5lib_impl.dart';
```

So, if you import "html.dart" and extend the `Element` class it gives you, your
subclass will extend the real honest-to-God DOM `Element` class when you run it
in Dartium. Likewise, when you compile it with dart2js, it will know you are
extending the real `Element` and not a wrapper.

In the meeting, we couldn't reach consensus on how important it is to support
this and similar use cases.

Supporting it requires being able to statically check types for compatibility.
In other words, we want the analyzer to be able to reliably tell you if the
`Element` class in `dart:html` is a reliable substitute for the one in
`html_interfaces.dart`. Likewise the one in `html5lib_impl.dart`.

The rules for doing that compatibility checking haven't been precisely defined
yet. We don't have consensus on how complex those are either. Florian describes
the amount of work as "huge". I think it's fairly simple.

Given that we don't know how important *or* how difficult to support this use
case is, the question is what do we do in the interim? The proposal is broken
into phases specifically because of this. The idea is that during the
experiment, we will initially implement phase 1 of static analysis which only
checks top-level functions and variables for compability.

What happens when a user does declare a public type in a config-specific library
then? I think we should just let the user try that even though they won't get
the assistance of static checking. The others in the meeting strongly feel this
should always be a static warning. When/if phase 2 is implemented, the warning
would be replaced with more fine-grained checking of types.

We've decided to implement phase 1's static checking and warn if a public type
appears in a config-specific library. After that, users can start trying out the
feature. Meanwhile, we'll work with the analyzer folks to see how difficult it
would be to implement phase 2.

## [Assert message param][37]

[37]: https://github.com/dart-lang/dart_enhancement_proposals/issues/37

After deciding that the assert message should be a string, we got feedback from
the team that they wanted to allow arbitrary objects. So, we've agreed to loosen
this and let the argument be anything.
