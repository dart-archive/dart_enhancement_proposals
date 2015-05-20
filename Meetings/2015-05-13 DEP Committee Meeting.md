Attendees: [Bob][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## [#5 Package spec]

[package spec]: https://github.com/dart-lang/dart_enhancement_proposals/issues/5

All the issues are closed. Some users added comments about using `.packages` as
the file name after the relevant bug was closed, but I think those didn't make
it under the wire.

For the language spec itself, we'll change it such that it says "package:" is
now left entirely up to the implementation to handle. Gilad will bring that
change to TC52.

All of the tools coming from the Dart team will implement the `packages.cfg`
semantics in the proposal.

So this one is accepted!

*Note: After the meeting, based on user feedback, Lasse changed the file name
to `.packages`.*

## [#28 Static analysis of calls on functions][28]

[28]: https://github.com/dart-lang/dart_enhancement_proposals/issues/28

We haven't all had a chance to look at this in detail yet, but we discussed it
some.

According to the spec, if you have an object whose static type is Function, it
should cause a static warning to invoke it. There is sense in this. Since the
Function class encompasses all functions, regardless of their arity or named
parameters, your call may well not match the actual signature of the function.
For example, this code will fail at runtime:

```dart
Function f = (a, b) => "got $a and $b";
f("just one arg");
```

The analyzer and dart2js don't currently implement this warning, so they each
have a bug here. If they did implement this, though, a lot of warnings will
appear in existing code. Most of the time, if you have a Function, you *do*
invoke it after all.

This DEP proposes tweaking the spec to not generate any static warnings if the
type is Function and the method is `call`. You could think of Function as being
"dynamic for calls" in the sense that wouldn't report static warnings related
to calls, but would still give you static warnings if you called any other
method on it that's not declared on the Function class.

This is a trade-off. There are lots of potential bugs where you call a function
with the wrong signature that will be masked by this. But it also avoids false
positives where you'd get a warning even when the signature *is* correct.

Of course, if you do want your invocations to be more tightly checked, you'd
want to use an actual function type instead of just Function.

I think the committee is OK with this in general, but Gilad wants to spend time
on the spec wording.

## [#26 Full optional parameters][26]

[26]: https://github.com/dart-lang/dart_enhancement_proposals/issues/26

Currently, a method can have optional positional parameters or optional named
ones, but not both. This proposal relaxes that limitation and allows a method
to have both optional position and optional named parameters.

There were some complexity concerns about this on the VM team, but they looked
into it and it seems it isn't so bad.

The proposed spec changes are a subset of the full list of things to change, so
Gilad filed an issue about that. He'll work with [Lasse][] to get the full
workup of spec changes.

[lasse]: https://github.com/lrhn

[Lars][] thinks it's generally a good thing. At a high level, it seems
reasonable, aside from the general hesitancy to add more complexity.

[lars]: https://github.com/larsbak

We do worry it will be more painful to implement than we hope. Kasper thinks
dart2js will struggle with this since there are places where we assume a method
has one or the other kind of optional parameter but not both.

In terms of priority, removing this limitation may not be as important as
removing other limitations like those in mixins.

So, the proposal needs some more spec work. In the meantime, we'd like
implementors to start taking a look at this and let us know if it's going to be
a problem. We do know this might be hard for DDC.

## Eliminating nested `const` in const expressions

Lasse is working on a proposal for this, but he hasn't submitted it yet. We'll
look at it more when he's ready for us too.
