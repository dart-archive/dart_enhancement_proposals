Let's say Jan has an idea improve the Dart language. Here's how she goes about it. From here on out, "she" refers to Jan, and "we" refers to the DEP committee.

Here's the short version:

1. Jan starts an informal discussion on the **TODO: name** mailing list.
2. She creates a new repo for her DEP containing the proposal, tests,
   prototype, examples, docs, etc.
3. When she's ready for us to see it, she [files an issue][issue] pointing to a
   commit in her repo, asking us to take a look.
4. We take that issue and label it "awaiting review".
5. We review the proposal and other artifacts in the repo. We give feedback by
   filing issues on her repo.
6. We add a comment on the issue she filed saying, "we're done reviewing" and
   change the label to "awaiting for revision".
7. When she's done responding to the issues we filed, she comments on the issue
   again.
8. We set it back to "awaiting review" and go to step 5.
9. If she bails or we think it can't move forward, we may explain why, and
   close the issue.
10. If we're happy with it, we create a new file under [`accepted/`][accepted]
    in our repo with the full text of her proposal. We close the bug as
    "approved".
11. At this point, the team can start implementing it (under a flag) and we can
    pass it on to TC 52.

[issue]: https://github.com/dart-lang/dart_enhancement_proposals/issues
[accepted]: https://github.com/dart-lang/dart_enhancement_proposals/tree/master/accepted

Here's the longer story:

## Conception

Jan keeps running into some problem in her Dart code and eventually has an idea
for a solution. The first thing she does is send an email to **TODO: list**.

*(I think we should make a new list for this to lower traffic. Something like
lang@dartlang.org or dep@dartlang.org.)*

She discusses it with the folks there—people both on the Dart team and off.
Many ideas will die here, which is good. Lots of problems already have good
solutions or maybe the solution is just infeasible. If people seem to think the
idea has merit and is worth pursuing, she goes to the next step:

## Proposal

She **creates a new Git repo**, likely on GitHub, but all that matters is that
it's somewhere public. That repo has a structure something much like:

    proposal.md  # DEP doc, based on template.
    spec.tex     # Language spec changes.
    test/        # Language tests.
    prototype/   # Implementation.
    example/     # Examples of using the proposal.

There may be other stuff in there too. Whatever supporting artifacts she thinks
are helpful. This repo is basically a little product in itself. She can
collaborate with other people, talk about it, take pull requests and issues,
whatever she wants. It's a living, breathing Git repo.

When she decides the proposal document and other artifacts (mainly the tests
and prototype) are ready for the committee to see, she **gets our attention by
filing an [issue][]** on the [dart_enhancement_proposals repo][dep repo].

[dep repo]: https://github.com/dart-lang/dart_enhancement_proposals

We'll provide a template for that issue that's basically:

    Note to others: please do not comment on the proposal in this issue.
    Instead, file issues on the proposal's repo.

    Hi, I have a proposal to enhance Dart. Its repo is: <repo>
    Please look at commit <commit hash>.

We call this the **tracking issue.** It stays open as long as her DEP is
in-progress and its label defines the current status of the DEP.

## Admission

We (probably [Bob][]) see that issue has come in. We label it "pending review".
At this point, it's a live DEP and it's our turn to review it.

[bob]: https://github.com/munificent

## Review

In a timely manner, we **review the proposal** and the other stuff in the repo.
We can do this individually, in meetings, whatever. We **provide feedback to
her by filing issues in her proposal's repo**.

Instead of her *pulling* feedback from us in something like a pull request to
our repo, we *push* feedback to her as issues. When we're done doing that, we:

* Add a comment on the tracking issue saying we're done reviewing.
* Change its label to "awaiting revision".

## Revision

Filing a bunch of separate issues for unrelated pieces of feedback lets her
manage responding to them individually. It lets other people also contribute
and comment on the issues as well. She can label them, triage them, fix them,
etc.

We can contribute in other ways too. We may send her pull requests if we want
to actively chip in. Meanwhile, she controls what actually lands so she doesn't
have to worry about us highjacking her proposal.

Other people can send her patches and pull requests. She can make commits to
her repo use branches, whatever she wants while she's revising things. This is
*much* more flexible than something like a single pull request for the lifetime
of the proposal.

Once she's happy that she's addressed all of the issues, she **comments on the
tracking issue** saying, "OK, please check it out again." She mentions the
commit that is the snapshot she wants us to consider.

We go through the review cycle again.

## Acceptance

Eventually, if things go well, we get to a point where we don't have any more
feedback to give. We have a commit that points to a version of the proposal,
spec changes, tests, and protoype implementation that we are happy to pass
along to TC 52. At that point we:

* Label the tracking bug "accepted" and close it.
* Copy the contents of her repo at the commit we accepted into
  [dart_enhancement_proposals][dep repo] under
  [`accepted/<number>/...`][accepted].

*TODO: Maybe we just need the proposal doc and spec changes?*

And we're done!
