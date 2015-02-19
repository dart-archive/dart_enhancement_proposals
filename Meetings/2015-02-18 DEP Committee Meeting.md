Attendees: [Bob][], [Gilad][], [Kasper][], [Lars][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl
[lars]: https://github.com/larsbak

## Tear-offs

Gilad took his tear-off proposal and converted it into [a Git repo][tear-offs].
He markdown-ified the original Google doc, but didn't follow [the
template][template] since the doc was already written.

He put the spec changes right in the proposal doc instead of a separate `.tex`
to play the part of a normal DEP author where the spec verbiage will get pulled
out later.

The committee seems generally happy with the proposal, though I'm not sure if
everyone has looked at it in detail.

[tear-offs]: https://github.com/gbracha/generalizedTearOffs
[template]: https://github.com/dart-lang/dart_enhancement_proposals/blob/master/DEP%20Template.md

## Package specs

Lasse has started converting his proposal into [a DEP repo][pkgspec]. We
haven't looked at it in detail yet. We'll go over it in more depth next week.

[pkgspec]: https://github.com/lrhn/dep-pkgspec

### Locating package specs

The proposal as currently stated will get rid of the primary "packages"
directory in each package and the symlinks it contains. What it doesn't address
is the secondary symlinked "packages" directories that get created in a
package's directories (`bin`, `test`, etc.) Lars would like to address those
too, which I whole-heartedly agree with.

Kasper noted that when an app is run by a tool like the Editor, it's easy for
us to just inject the explicit package-spec path so the VM can find it.

I agreed with that, but it still leaves a rough user experience when a user is
running an app directly from the command-line. I suggested the VM could walk up
directories looking for a package spec file.

Kasper said that isn't desirable in some cases, like serving an app over HTTP,
but could work if we limit it to apps run from local files. I think that
limitation is fine.

We discussed a bit about how to handle symlinks when doing this but didn't
reach a conclusion. Kasper thinks most shells use `$PWD` to implement `cd ..`
and that allows them to treat symlinked directories more or less like normal
directories.

### Syntax

We spent some time discussing the syntax. The VM wants something very very
simple to parse since they have to implement it and it's in the path of app
startup.

I said something more open-ended and extensible might let us unify the package
spec and lockfile. Lockfiles have more data in there that the package spec
doesn't care about but if the format was open-ended, we could put it in there
and have other tools just ignore it.

Lars brought up that a package-spec will have absolute paths to things in the
user's cache, so you wouldn't want to check that into source control anyway.
Given that (which is absolutely right), it doesn't make sense to unify those
files, so we can probably keep the syntax dead simple.

We'll spend some time discussing this and be ready to talk more about it next
week.

## Metaclasses

After the last meeting Florian brought up that the propsal will have some
negative size impact in dart2js, but we don't know how much.

Kasper volunteered to do a simple experiment to get a pessimistic worst case
size impact. If that isn't too bad, then we're in good shape. If it is, we may
have to do more investigation to see if we can bring that size down.

## Other stuff

* Gilad brought up that the VM team doesn't have direct representation in the
  DEP committee meetings, which we may want to address.

* We're ready for the team to write more DEPs and get more in the pipeline.
