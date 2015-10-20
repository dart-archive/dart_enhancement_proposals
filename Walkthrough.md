Let's say Kate has an idea improve the Dart platform. Here's how she goes about
it. From here on out, "she" refers to Kate, and "we" refers to the DEP
committee.

Here's the short version of the steps she takes:

1. Kate starts an informal discussion on the [`core-dev@dartlang.org`][core-dev]
   mailing list.
2. She creates a new repo for her DEP containing a file named `proposal.md`
   based on our [template][].
3. When she's ready for us to see it, she [files an issue][issue] pointing to a
   commit in her repo, asking us to take a look.
4. We take that issue and label it "draft".
5. When we meet, we check out her proposal and give feedback. She responds and
   revises her proposal.
6. If we get to a point where we are happy with the proposal, we change its
   status to "experimental" and the team begins implementing it behind a flag.
7. Based on how that goes, we refine the proposal, or possibly close it if
   it doesn't work out in practice.
8. If we're happy with it, we create a new directory under
   [`Accepted/`][accepted] in our repo with the full text of her proposal. We
   close the bug as ["accepted"][accepted issues].
9. At this point, the proposal goes to TC52. If they are happy with it, the
   experimental flag is removed and the feature is shipped.

[core-dev]: https://groups.google.com/a/dartlang.org/forum/#!forum/core-dev
[template]: https://github.com/dart-lang/dart_enhancement_proposals/blob/master/DEP%20Template.md
[issue]: https://github.com/dart-lang/dart_enhancement_proposals/issues
[accepted]: https://github.com/dart-lang/dart_enhancement_proposals/tree/master/Accepted
[accepted issues]: https://github.com/dart-lang/dart_enhancement_proposals/issues?q=label%3Aaccepted+

Here's the longer story:

## Conception

Kate keeps running into some problem in her Dart code. She asks around on the
[main mailing list][misc] and [StackOverflow][] but no one seems to have a good
solution or workaround. Eventually, she has an idea for a solution that
requires a change to Dart itself. The next thing she does is send an email to
[`core-dev@dartlang.org`][core-dev].

[misc]: https://groups.google.com/a/dartlang.org/forum/#!forum/misc
[stackoverflow]: http://stackoverflow.com/tags/dart

She discusses it with the folks there—people both on the Dart team and off.
Many ideas will die here, which is good. Lots of problems already have good
solutions or maybe the solution is just infeasible. If people seem to think the
idea has merit and is worth pursuing, she goes to the next step:

## Writing the Proposal

She **creates a new Git repo**, likely on GitHub, but all that matters is that
it's somewhere public. Initially the repo will probably just contain one file:

    proposal.md  # DEP doc.

The proposal is a [Markdown][] document that she creates by copying [our
template][template] and filling it in.

[markdown]: http://en.wikipedia.org/wiki/Markdown

That's all that's *required* at this point, but she is more than welcome to add
other files:

    spec.tex     # Language spec changes, if any.
    test/        # Language tests.
    prototype/   # Implementation.
    example/     # Examples of using the proposal.

Whatever supporting artifacts she thinks are helpful. The repo is basically a
little product in itself. She can collaborate with other people, talk about it,
take pull requests and issues, whatever she wants. It's a living, breathing
workspace.

She probably *won't* have actual proposed spec language changes, at least not
initially. The set of people who can write that kind of stuff correctly is very
small. Fortunately, we have a few on staff, so as Kate's proposal reaches
maturity, we can help fill this in. Of course, she's welcome to work on it too.
It's her proposal, after all.

When she decides the proposal document and other artifacts are ready for the
committee to see, she **gets our attention by filing an [issue][]** on the
[dart_enhancement_proposals repo][dep repo].

[dep repo]: https://github.com/dart-lang/dart_enhancement_proposals

The text of the issue should be:

    This is the tracking issue for DEP: **<proposal name>**.

    The proposal lives [here][repo].

    *Note: This issue is a tracking bug for the status of the proposal. To
    comment on the proposal itself, file issues on its [repo][], not here.*

    [repo]: <repo URL>

She fills in the `<proposal name>` and `<repo URL`> parts. This **tracking
issue** stays open as long as her DEP is in progress. It's the canonical
identifier for her DEP. Its [label][] defines the current status of the DEP.

[label]: https://github.com/dart-lang/dart_enhancement_proposals/labels

## A Living Draft

We (probably [Bob][]) see that issue has come in. We label it "draft". At this
point, it's a live DEP. From here on out, when the committee meets, it will be
on our agenda.

[bob]: https://github.com/munificent

In a timely manner, we **review the proposal** and the other stuff in the repo.
We **provide feedback to her** by filing issues in her proposal's repo, sending
her email, or in the [DEP meeting notes][].

[dep meeting notes]: https://github.com/dart-lang/dart_enhancement_proposals/tree/master/Meetings

In general, filing issues is the most reliable way for us or others to give her
feedback. It lets her respond to them individually. It means other people also
contribute and comment on the issues as well. She can label them, triage them,
fix them, etc.

We can contribute in other ways too. We may send her pull requests if we want
to actively chip in. Meanwhile, she controls what actually lands so she doesn't
have to worry about us hijacking her proposal.

Other people can send her patches and pull requests. She can make commits to
her repo use branches, whatever she wants while she's revising things. This is
*much* more flexible than something like a single pull request for the lifetime
of the proposal.

When she and her contributors make changes, they let us know so we check up on
her proposal the next time we meet. Eventually, if things go well, we get to a
point where we don't have any more feedback to give but are still excited about
the proposal. We've learned all we can from a text proposal. It's time to get
real.

## Implementing the Proposal

We mark the tracking issue as "experimental". This is the signal to the Dart
team and other contributors that we can begin putting resources into
implementing the proposal. It will be behind an **experimental flag** since it
is not a supported part of the Dart platform (yet), but will be a real, working
implementation. Any user who opts in to that flag will be able to try it out and
give us feedback.

We learn a lot during this. As the implementors run into ambiguous corners of
the text or other issues, they give her feedback. She tightens and revises the
proposal, and (likely with help from the team) produces final spec language for
it.

Once we've got a complete spec, solid working code, and real user feedback, we
can tell if this is an overall asset to the Dart platform or not. If it goes
well, we are ready to commit to it.

## Acceptance

At this point we:

* Label the tracking bug "accepted" and close it.
* Copy the contents of her repo into
  [dart_enhancement_proposals][dep repo] under
  [`Accepted/<number>/...`][accepted].

Now, the proposal has exited the DEP process and moves into the more official
Ecma standardization process. If we've done our job well, the proposal will
satisfy the committee and will get ratified pretty much as-is.

However, the TC52 group always has final say over what makes it into the
standard and there is a chance the proposal will be modified or possibly even
rejected. Our goal with the DEP process is to make sure the proposals we deliver
are so great that they slide right in and everyone is happy.

If TC52 gives it the thumbs up, we remove the experimental flag and the feature
has now shipped and is officially supported.
