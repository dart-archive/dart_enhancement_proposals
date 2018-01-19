## DEPRECATED

**While we are still very much actively evolving the language, we are no longer 
using the DEP process for managing these changes.** 

This repository maintains and tracks **Dart Enhancement Proposals**. These
guide the evolution of the [Dart][] programming language. It's similar to
[Python's PEPs][pep] process and [Scala's SIPs][sip].

[dart]: https://www.dartlang.org/
[pep]: https://www.python.org/dev/peps/
[sip]: http://docs.scala-lang.org/sips/

We use the issue tracker in this repo to track ongoing proposals:

* [In-progress DEPs][open]
* [Accepted DEPs][accepted]
* [DEPs awaiting author's revision][revise]
* [DEPs awaiting committee feedback][review]

[open]: https://github.com/dart-lang/dart_enhancement_proposals/issues
[accepted]: https://github.com/dart-lang/dart_enhancement_proposals/issues?q=label%3Aaccepted+
[revise]: https://github.com/dart-lang/dart_enhancement_proposals/labels/awaiting%20revision
[review]: https://github.com/dart-lang/dart_enhancement_proposals/labels/awaiting%20review

## What is a DEP?

A DEP is a [detailed, concrete proposal][template] to change part of the core
Dart platform. "Platform" usually means the Dart language itself, but DEPs may
also apply to core libraries or other tools that ship with the Dart SDK.

[template]: https://github.com/dart-lang/dart_enhancement_proposals/blob/master/DEP%20Template.md

DEPs are the primary way that the Dart team and the larger Dart community work
together to improve Dart over time. A DEP is a *technical* artifact in that it
specifies *what* the proposed change is and *how* it can be implemented or
specified. By the time a DEP reaches acceptance, it usually contains tests, a
working implementation and spec language changes.

At the same time, a DEP is *social* artifact. It's a living repository that
lets interested parties work together and build consensus on *why* the language
should be changed in a certain way. It contains rationale and alternate
approaches that were considered. Iterating on the DEP in public ensures people
with good ideas can participate.

## What is this process for?

Language design is hard. Designing a syntax and semantics that is elegant,
expressive, and can be implemented efficiently requires deep understanding of
parsers, compilers, and virtual machines.

Meanwhile, Dart users are writing sophisticated applications and frameworks
with complex needs that require deep domain knowledge to understand.

To make a great language that can be used to write great programs means these
people need to work together. The DEP process is how we do that. We want to:

* Create an open, collaborative, and inclusive Dart ecosystem.
* Be responsive to developer requirements.
* Give the community a sense of shared ownership and stewardship.
* Be transparent about the work leading to Dart language changes.
* Ensure rationale for changes (or decisions not to change) is clearly
  communicated.
* Close the loop and ensure stakeholders are happy before a change is
  finalized.

This all sounds great for the community, which is of course what matters most.
But the language team's resources are finite and this involves more work
documenting and carefully following processes.

The other side of that coin is that the DEP process places some of the burden
of due diligence on the proposer. It's up to the DEP author to clarify
rationale, build consensus, and work through the technical challenges of the
proposal. This helps us make effective use of the language team's time.

## So anyone can change Dart?

Anyone can create and champion a DEP, but this does not mean that Dart is a
democracy. The DEP process is a key part of how we decide how Dart should grow,
but it's only one part. DEPs are managed by the *DEP committee*.

This is a handful of Dart team members who handle the adminstrivia of tracking
proposals through the process. They also ultimately decide which proposals get
accepted and which do not. Keeping this in the hands of a small group ensures
Dart stays compact and consistent.

Also, because Dart is an open [Ecma specification][spec], [TC52][] has
final say on what changes land in the spec. The DEP
committee *is* approved and tasked by TC52 to manage the inflow of proposals
for discussion. However, TC52 members can always bring proposals in directly or
change them after they have been accepted. This is inherent in the Ecma
standards process.

[spec]: https://www.dartlang.org/docs/spec/
[TC52]: http://www.ecma-international.org/memento/TC52.htm

## How does a proposal get accepted?

The actual mechanics of getting your proposal into the platform rely on Git and
GitHub. Your DEP will be a repo, its status is tracked with an issue here. To
see how all of that plays out, read the [walkthrough][].

[walkthrough]: https://github.com/dart-lang/dart_enhancement_proposals/blob/master/Walkthrough.md

As it works its way through that process, your proposal will be in one of a few
states:

### Draft

A DEP starts with you having an idea. You discuss it informally with the
community, usually on the [`core-dev@dartlang.org`][core-dev] list. At this
point, it's just a concept. You and whoever else is interested iterate on it
like this for a while.

[core-dev]: https://groups.google.com/a/dartlang.org/forum/#!forum/core-dev

If the concept comes together and seems like a workable idea, you [write up a
proposal][template]. You **file a tracking issue for the DEP**. Your proposal is
now a live **draft** DEP and the committee will look at it.

This begins an iterative design process with you, the DEP committee, and any
other interested stakeholders. People give you feedback, file issues, etc. You
tweak and flesh out your proposal and keep us informed as it evolves.

### Experimental

If things go well, the proposal reaches a state where we can't learn anything
more about it without real working code. No one on Earth can do flawless design
up front, so we don't consider a proposal solid until we've cast it into code
hard code.

If we feel the proposal is promising and are ready to commit resources to it
proving it out, it becomes **experimental**. This means the Dart team and any
other interested contributors can begin working on an implementation. It will be
behind an opt-in experimental flag, but this will culminate in real,
production-quality code.

### Accepted

Once we have a working experimental implementation, we should have a handle on
all of the tricky corners of its behavior. Equally important, we can now get
real-world feedback from users.

If all of that goes well, we now have confidence that the proposal is a winner.
We mark it **accepted**. This means that, as far the DEP committee is concerned,
this should become an official part of the Dart platform.

You sign the [external contributor form][] if you haven't already and the
proposal goes to TC52. Please note that TC52 operates under a royalty-free 
patent policy, [RFPP][] (PDF). If TC52 approves the feature, the experimental 
flag is removed and the implementation ships.

[external contributor form]: http://www.ecma-international.org/memento/TC52%20policy/Contribution%20form%20to%20TC52%20Royalty%20Free%20Task%20Group%20as%20a%20non-member.pdf

This is the path an accepted proposal takes, but not every DEP makes it to the
end.

### Inactive

One of the realities of open source is that the time contributors have is often
limited and unpredictable. Sometimes, the author of a DEP doesn't have the
resources to keep pushing it forward. Or it may be that *we* don't have enough
time to focus on it right now. Prioritization is always important and some good
ideas may not be good ideas for *today*.

When that happens, a proposal may be marked **inactive**. This means we think it
has merit but aren't actively working on it. We won't check up on it during DEP
meetings and won't spend more time hacking on an experimental implementation.
When our schedules or other tasks get finished, we may resume an inactive
proposal.

### Closed

Occasionally, a proposal hits a dead end during this process. We discover things
problems with it that can't be solved, or it becomes clear that it isn't worth
doing. In that case, the DEP will be **closed**.

This sounds sad, but closing changes is often good because it helps keep the
platform small and focused. In many cases a DEP is closed because an even better
solution is found.

A DEP may become closed during any stage of the DEP process. From the draft
through the experimental implementation, we are constantly learning more about
the proposal, and a showstopper may appear at any time.

# How does the committee work?

We meet weekly to run through all of the live (draft and experimental) DEPs
awaiting our feedback. We publish minutes from these meetings [here in the
repo][minutes]. It's our job to explain what further work we think a DEP needs
if it isn't moving forward. The author of a DEP may be asked to join in the
meeting.

[minutes]: https://github.com/dart-lang/dart_enhancement_proposals/tree/master/Meetings

Currently, the DEP committee is:

* [Bob Nystrom][bob]
* [Florian Loitsch][florian]
* [Gilad Bracha][gilad]
* [Kasper Lund][kasper]

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[florian]: https://github.com/floitschG
[kasper]: https://github.com/kasperl
[rfpp]: http://www.ecma-international.org/memento/TC52%20policy/Ecma%20Experimental%20TC52%20Royalty-Free%20Patent%20Policy.pdf

