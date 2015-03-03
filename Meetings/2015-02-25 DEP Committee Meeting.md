Attendees: [Anders][], [Bob][], [Gilad][], [Ivan][], [Kasper][], [Lars][], [Lasse][].

[anders]: https://github.com/anders-sandholm
[bob]: https://github.com/munificent
[erik]: https://github.com/eernstg
[gilad]: https://github.com/gbracha
[ivan]: https://github.com/iposva
[kasper]: https://github.com/kasperl
[lars]: https://github.com/larsbak
[lasse]: https://github.com/lrhn

## TC52 Meeting

TC52 met this week. Gilad promised a final proposal for [generalized
tear-offs][] will be ready for them by the next meeting on March 19th. He
showed them the repo with the current proposal.

[generalized tear-offs]: https://github.com/dart-lang/dart_enhancement_proposals/issues/3

Anders reviewed the DEP process and how its role relates to theirs. The TC52
folks are all happy to assist.

I asked what the status of tear-offs is since it's considered "accepted" but
Gilad mentioned there may be some changes based on Lasse's feedback. It *is*
accepted, which means it's been forwarded to TC52, but there may be some minor
adjustments there.

## [Package spec][]

[package spec]: https://github.com/dart-lang/dart_enhancement_proposals/issues/5

This is an initiative to eliminate the symlinks we create to deal with
"package:" imports. There are two flavors of symlinks:

1. Pub creates a real "packages" directory in the root of your package. It
   contains a symlink for each package your app depends on, pointing to that
   package's real location.

2. Then, in all of the subdirectories in your app that may contain a Dart
   entrypoint, we make secondary symlinks that point to that main "packages"
   directory.

Having an explicit package specification file that tells Dart explicitly where
to find a package removes the first kind. We also want to eliminate the
secondary ones. (They're particularly annoying to users since they clutter up
their application's directories.)

What we need to discuss now are:

1. The syntax for the file.
2. How tools find the file so that we can address point #2 above.

Then we took these and discussed them out of order:

### Locating the package spec

It will be a file on disc in the project's root directory&mdash;the same place
the main "packages" directory which it replaces appears now.

However, the VM doesn't know what a "project" or "package" is. It doesn't
currently know how to find that. If you run an entrypoint that happens to be in
the root directory, this works. But if it's in a subdirectory, it won't.
(That's why we currently make all of the secondary "packages" symlinks.)

One fix would be to have the VM walk up subdirectories until it finds a package
spec. It's ugly, but it works.

If a Dart program is run from the IDE, the IDE can provide an explicit path to
the package spec. For web apps, the dev server can emulate the existing
behavior. It's only if the user directly invokes the VM from the command line
that we want to crawl back to find the file.

### Syntax

It's a file on disc. It contains a mapping from strings to string. The key is
the first path component of a "package:" URL and the value is the base URL that
the rest of that package's path should be resolved against. The value can be a
path or even an HTTP URL.

One suggestion is to make the syntax a Dart map literal or to use some larger
subset of Dart syntax. That should hopefully let the VM reuse its existing C++
Dart parser for it.

### How does it come into play?

We discussed when this file needs to be parsed by the VM. Since even the
entrypoint URL passed to the VM can use "package:", it will be before it
executes any user code.

### How does a user make use of it?

Pub will generate it for the user after running pub get/upgrade, just like it
does with the lockfile. We don't expect users to hand-edit it. The first line
will say something along the lines of:

```
This was generated. Keep your dirty fingers away from it.
```

(Maybe not quite so harsh.)

It is with a heavy heart that we accept this means adding a third file to the
top level of the user's package. It has some key differences from both the
pubspec and lockfile, so we can't unify it with either.

However, it does let us get rid of the "packages" directory at the top level,
so the number of generated entries is the same.

### How does it work internally?

We have internal customers that sometimes need to map a package to multiple
directories that are overlaid on top of each other. Within a single package,
one file may be physically located in directory A while another comes from B.
Basically, they need search paths.

This proposal doesn't help that. That may be OK&mdash;we could consider that
out of scope. But we could try to do something.

One option would be to let the user provide an imperative location procedure
instead of a declarative package spec. Then they could implement their own
search-path-like behavior.

Other options:

* The VM could allow multiple package specs and search them in order.
* We could allow multiple entries for the same key in the package spec.

Our current feeling is to make the right design for the general case and then
try to find a not-too-terrible hack to help here.

We agree a file is a good solution. Ivan, Florian, Dan Rubel (who works on the
analyzer) and Bob will figure out a syntax they all agree on.

## Other DEP proposals

We're still looking for more proposals to put into the pipeline.

Gilad mentioned a proposal for null-aware operators at the TC52 meeting. It's
simple enough that he thinks we can get something accepted and ready for them
at the March meeting.

Gilad will write up a DEP. It's got:

* A `?.` safe navigation or "Elvis" operator.
* A `??` null coalescing operator.
* A `?=` operator that assigns only if the RHS is not null.

## [Metaclasses][]

[metaclasses]: https://github.com/dart-lang/dart_enhancement_proposals/issues/4

Kasper looked into how the metaclass proposal would affect generated JS size in
dart2js. The short answer is that it doesn't look bad enough to rule out the
proposal. It seems to be relatively easy to keep track of the use of
metaclasses.

One worrisome thing is that if you call `runtimeType` on anything, dart2js may
lose track of which runtime types are being used. That can mean it ends up
having to hold onto static methods in the generated code since it can't tell
that they aren't in use.

However, there don't seem to be many static methods in the code they looked at,
and most of them already are being used. So not tree shaking them is probably
not a large change.

So, at least for codebases that they looked at, this feature doesn't seem to
have a large impact. Now we need to evaluate the proposal to see if we like it.

## Configurable imports

Lasse has a proposal for this but it's not on GitHub yet. Gilad also has a
configurable library proposal but Lars doesn't think it addresses the same
problem. Lasse's proposal addresses our most pressing concern: keeping the
configuration hidden from the user. (Conversely, Gilad's proposal addresses
other problems which Lasse's doesn't.)

Lasse will DEP-ify this and send it out. We'll discuss it more next week.

## Agenda for next week

What's on the table? We can talk about metaclasses, but we've also got
null-aware operators and configurable imports. Lars thinks the operators are a
slam dunk so we'll do those first, then configurable imports and then if we run
out of time, we'll let metaclasses slip.

## Opening the DEP process up the public

We talked about it some more. We've got a bit more documentation clean up to do
and then it's ready to launch. We're aiming for sometime next week.
