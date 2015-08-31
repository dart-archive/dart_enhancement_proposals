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
specified. By the time a DEP reaches maturity, it will usually contain tests, a
prototype implementation and spec language changes.

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

## How do I create a proposal?

Sometimes, a flowchart really is the right answer:

![](https://dart-lang.github.io/dart_enhancement_proposals/Flowchart.svg)

Blue boxes are controlled by the author, and green boxes are handled by the DEP
committee. Rectangles are states a proposal can be in, and rounded boxes are
actions people can take.

The workflow goes something like this:

1. It starts with you having an idea. You discuss it informally with the
   community, usually on the [`core-dev@dartlang.org`][core-dev] list. At this
   point, it's just a **concept**. You and whoever else is interested iterate
   on it like this for a while.

2. If the concept comes together and seems like a workable idea, you write up a
   proposal. You **file the DEP** to bring it to the committee's attention.
   Your proposal is now a live DEP **awaiting review** from the committee.

    1. Create a repository on GitHub. Give it a title like `dep_<short name of your proposal>`.
    
    2. Inside your repository, create a filed named _proposal.md_
       with the contents from this [template][deptemplate].
       
    3. Fill out the template as best as you can.
    
    4. Send the link to your proposal to [`core-dev@dartlang.org`][core-dev]
    
    5. File an [issue][depissues] requesting feedback.
       
[deptemplate]: https://github.com/dart-lang/dart_enhancement_proposals/blob/master/DEP%20Template.md
[depissues]: https://github.com/dart-lang/dart_enhancement_proposals/issues

3. The committee meets and goes over your proposal in detail. We do one of:

    1. We **give feedback**. This means the DEP has merit but needs more
       work. Now the ball is back in your court and the DEP is **awaiting
       revision** from you.

    2. We **accept** it. We think the DEP is in great shape, and would be
       an improvement to the platform. Once you have submitted Ecma TC52's
       [external contributer form][], we hand the DEP off to TC52 to
       take it from there. Your proposal has exited the DEP process and it's
       now up to TC52 to handle it.

    3. We **decline** it. This means we don't think the proposal is likely
       to become something that will move the platform forward. This sounds
       bad, but declining changes is often good because it helps keep the
       platform small and focused.

4. If we gave you feedback, it's now up to you to **revise** your proposal.
   This is a good time to take feedback from the rest of the community to. Once
   you're satisfied, you send it back to us for another round of review.
   Multiple cycles of this may occur, though everyone naturally wants to
   minimize it.

[core-dev]: https://groups.google.com/a/dartlang.org/forum/#!forum/core-dev
[external contributer form]: http://www.ecma-international.org/memento/TC52%20policy/Contribution%20form%20to%20TC52%20Royalty%20Free%20Task%20Group%20as%20a%20non-member.pdf

There's also the possibility that you'll abandon your proposal. This may
because you found a better way to solve your problem, or another DEP superseded
it or you simply doesn’t have the time to work on it or find someone else to
take the helm.

The actual mechanics of this process rely heavily on Git and GitHub. Your DEP
will be a repo, its status is tracked with an issue here. To see how all of
that plays out, read the [walkthrough][].

[walkthrough]: https://github.com/dart-lang/dart_enhancement_proposals/blob/master/Walkthrough.md

# How does the committee work?

We meet weekly to run through the all of the DEPs awaiting our feedback. We
publish minutes from these meetings [here in the repo][minutes]. It's our job
to explain what further work we think a DEP needs if it isn't ready to be
accepted. The author of a DEP may be asked to join in the meeting.

[minutes]: https://github.com/dart-lang/dart_enhancement_proposals/tree/master/Meetings

Currently, the DEP committee is:

* [Anders Thorhauge Sandholm][anders]
* [Bob Nystrom][bob]
* [Erik Ernst][erik]
* [Gilad Bracha][gilad]
* [Ivan Posva][ivan]
* [Kasper Lund][kasper]
* [Lars Bak][lars]
* [Lasse Reichstein Nielsen][lasse]

[anders]: https://github.com/anders-sandholm
[bob]: https://github.com/munificent
[erik]: https://github.com/ErikErnst
[gilad]: https://github.com/gbracha
[ivan]: https://github.com/iposva
[lars]: https://github.com/larsbak
[lasse]: https://github.com/lrhn
[kasper]: https://github.com/kasperl
