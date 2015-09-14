Attendees: [Bob][], [Florian][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## [Generic methods][generic methods]

[generic methods]: https://github.com/leafpetersen/dep-generic-methods

Florian spent some time prototyping what the Dart core libraries would look like
if we added generic methods. The standard methods like `Iterable.map()` and
`Iterable.fold()` look like you expect, are easy, and just work.

It's hairier in the [Zone][] API. That API is highly generic and has lots of
higher-order functions. For something like `registerCallback()`, if you want the
function you pass to it to be fully typed, you end up needing a lot of type
parameters on the method itself. It's feasible, but it may be a lot of work.

[zone]: https://api.dartlang.org/1.12.1/dart-async/Zone-class.html

That API also brings up questions about whether generic methods are first class.
Can you have a first-class function that you can invoke with type arguments? We
discussed this before at the Dart Summit and other places, but I'm not sure if
we've reached consensus yet.

The [ZoneSpecification][] class is configured by the user by passing in a bunch
of callbacks. Those callbacks may need to be generic to fully support how the
Zone API wants to call it. This might be an extreme, uncommon case that we don't
have to address.

[ZoneSpecification]: https://api.dartlang.org/1.12.1/dart-async/ZoneSpecification-class.html

Florian offered to write up some more details on how the experiment is going so
far to share with us. I asked him to push it out as a branch on the SDK repo.

## [Non-nullable types][nnbd]

[nnbd]: https://github.com/dart-lang/dart_enhancement_proposals/issues/30

Florian has started prototyping non-nullable type support in dart2js. He added
some temporary syntax for it to the parser. Then started implementing the
propagation so that nullable and non-nullable types flow through the system and
report errors.

For example, if you do `o.x` without having checked that `o` is not null, its
type annotation must be non-nullable. Likewise, if a function returns `null`,
it's return type must be nullable. Then dart2js propagates outwards from there
and sees what kind of clashes occur.

He thinks it's going to go well, but he's a little afraid of being able to make
it work for generic types. He only just started working on this, but he's hoping
to get it far enough to see what kinds of changes we'd need to make to dart2js
and our core libraries to get them happy with non-nullable types. He thinks it's
even possible to get checked mode for non-nullable types working in dart2js.

When this is further along, he'll write something up about how the experiment
went.

## Meeting format

We've started having really important discussions about what the next major step
for Dart may look like. But it doesn't seem like the DEP meeting is the best
venue for that. It may set confusing expectations that "Dart 2.0" is nearer or
more concrete than it really is.

We are considering fundamental changes, and we want to have these discussions in
the open, but we want people to understand the tentative context around them.
The DEP meetings, which are pretty concrete and near-term make that confusing.

So we've decided to split the meetings up. This meeting will go back to being a
short, focused meeting to discuss the current ongoing proposals.

For larger language evolution discussions, we haven't figured out the right
forum yet&mdash;difficult when you are open source and your team is spread
across a few time zones&mdash;but we will.

## DEP status

The list of DEPs could stand to have some of their statuses cleaned up. They are
basically in one of a few buckets:

* A while back, Lars and Gilad met to discuss which proposals Lars feels are a
  high priority. For the proposals that didn't make that list, we think they
  would be nice to have, but we don't want to place to heavy of an
  implementation burden on the team all at once. Proposals in the "nice to have"
  bucket are basically on ice for now until we free up more bandwidth.

* A few proposals are "awaiting revision". It basically means we've given the
  author feedback and we're content to leave the ball in their court until they
  want to get back to us and push for some action.

* A couple of proposals like generic methods are being worked on by people on
  the team.

* Then there are a few proposals around configuration-specific code...

## Configuration-specific code

Last week, I met with most of the stakeholders around this. Our discussions
lately have mostly coalesced around a Florian's "interface library" proposal
with some refinement based on [Erik's proposal][variation]. Florian's is itself
a variation of [Lasse's original proposal][configured imports] around this.

What I'm doing now is writing a standalone document that pulls together all of
the various bits and pieces we've talked about in other docs and email threads.
I'll send that out as soon as I can and then hopefully that will be the proposal
we do an experimental implementation of.

It feels to me like the discussions are tapering to something concrete.

[configured imports]: https://github.com/lrhn/dep-configured-imports
[variation]: https://github.com/eernstg/dep-configured-imports

## Package map and resources

There's a library issue being discussed about package maps. Should the core
libraries give you a way to locate a package inside the program? It only makes
sense on the standalone VM, so this would be a "dart:io" API.

There are some open issues around this because the VM currently loads the
package map lazily, but it's being discussed. We need to figure out soon because
it interacts with the Resource API which is also in-progress.
