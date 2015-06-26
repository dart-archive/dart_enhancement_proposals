#Let static analysis allow any call on `Function` type.

## Contact information

Name: Lasse R.H. Nielsen  
E-mail: lrn@google.com  
[DEP Proposal Location][]  

## Summary

The current specification does not consider the type `Function` to be callable.
Example:
```dart
   void foo(Function bar) { return bar(); }
```
This example should give a warning at the call point `bar()` because the static type of `bar` does not have a method called `call`.

This proposal proposes to remove the requirement for a warning when calling something with the static type `Function`, effectively assuming that it has *some* member named
`call`.

## Background and motivation
The [Dart standard][] currently requires warning for code that calls expression with static type `Function`, where `Function` is the type in `dart:core`.

Implementations of Dart have not produced this warning ([Analyzer Issue]), and existing code has assumed that code as the one above is perfectly fine.

In practice, the Dart type system makes it somewhat cumbersome to specify a function type for fields or return types, and code has been written using `Function` indended just as a sligtly more precise alternative to `dynamic`. This includes code in the Dart platform libraries.

Changing the analyzer behavior is problematic because it will cause existing code to give new warnings. That's not an argument against fixing the behavior, but it shows the scale of the mis-use. If a significant number of programmers is using a bug as a feature, it suggest that there is a need for that feature. Changing the specification to match the implementations would give the user the feature that they are already using, only with a full specification behind it.

## Proposal
The [Dart standard][] section 16.7.1 (Ordinary invocation) has a paragraph listing exceptions where a warning is not needed, prefixed by:
> Let /T/ be the static type of /o/. It is a static type warning if /T/ does not have an accessible (6.2) instance member named /m/ unless either:`
To this list, a third item should be added:
> * /T/ is **Function** and /m/ is **call**.

Similarly, section 16.18.7 (Property Extraction) has a similar list that should also have the same third item added. This allows reading `o.call` from an object `o` with static type `Function` without getting a warning. 

The result of the property extraction will have type `dynamic`.
If possible, it might also be worth it to special case the static type of the property extraction of `call` on somthing typed `Function` to be `Function`. It's not necessary to cover the current uses

## Implications
The proposed change disables some type-checking that the current specification requires.
No current implementation has actually implemented the specification, and the change would make the current implementations be correct. As such, no user code should be affected.

The required warnings would detect code that
* has typed a function value as `Function`, and
* is calling the function or reading its `call` method.
Such code tends to be deliberate since the alternative to specifying `Function` is to default to `dynamic`. As such, enforcing the warnings would likely just turn the type annotation back to `dynamic` for such code, catching even fewer actual errors instead of catching more.

## Deliverables

### Language specification changes

The changes to the specification are simple and described above..

### A working implementation

No implementation need to change to support the changed specification, since they are already implementing the proposed static semantics.

Pure runtime implementations like the VM are unaffected by the change.

## Patents rights

TC52, the Ecma technical committee working on evolving the open [Dart standard][], operates under a royalty-free patent policy, [RFPP][] (PDF). This means if the proposal graduates to being sent to TC52, you will have to sign the Ecma TC52 [external contributer form]() and submit it to Ecma.

[Analyzer Issue]: http://dartbug.com/21938
[DEP Proposal Location]: https://github.com/lrhn/dep-functiontype/
[Dart standard]: http://www.ecma-international.org/publications/standards/Ecma-408.htm
[rfpp]: http://www.ecma-international.org/memento/TC52%20policy/Ecma%20Experimental%20TC52%20Royalty-Free%20Patent%20Policy.pdf
[form]: http://www.ecma-international.org/memento/TC52%20policy/Contribution%20form%20to%20TC52%20Royalty%20Free%20Task%20Group%20as%20a%20non-member.pdf
