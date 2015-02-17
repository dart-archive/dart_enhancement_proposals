Attendees: [Anders][], [Bob][], [Erik][], [Gilad][], Lars, Lasse.

[anders]: https://github.com/anders-sandholm
[bob]: https://github.com/munificent
[erik]: https://github.com/ErikErnst
[gilad]: https://github.com/gbracha

## When should the committee meet?

This is surprisingly tricky because half of the committee is in Denmark and the other half is on the West Coast of the US. In addition, some of our more illustrious committee members tend to have pretty full schedules. After some deliberation and calendar-poking we arrived at:

* Every Wednesday from 11:00am–12:00pm, Pacific Time

Through a miracle of timing, now is actually a good time to find open conference rooms in the ever-crowded Mountain View campus so Gilad will be staking out his territory forthwith.

## What is the scope of the committee?

Three categories of improvement:

* Language
* Core libraries
* The broader "SDK"

By the last, we mean tools and other core parts of the Dart platform. We'll treat all three of these as under the holistic umbrella of the DEP committee.

## What issues will we be going over first?

Gilad has two proposals that are pretty mature:

 *  One on broadening what kind of tear-offs are supported. Right now, Dart
    only lets you tear off methods, like so:

    ```dart
    var tearOff = "some string".toString;
    // tearOff is now a closure that invokes toString() on
    // "some string" when called.
    print(tearOff()); // "some string"
    ```

    This would extend that to support tearing off constructors and possibly
    other members.

*   Another proposal for making runtime `Type` objects more capable.

While these have already been written up, we'll use them as canaries to run through the proposed DEP workflow so we can get a sense for how all of the mechanics work in practice.

Doing this is more work, but it will let us iterate on the process itself before we open it up to other contributors.

Anders: "Markdown FTW! Who needs LaTex?"

## Documenting the DEP process

We went through some less-than-thrilling administrivia about who can review
documentation commits to the dart_enhancement_proposals repo itself.

For substantive patches that change our official workflow, we need someone on
the committee itself like Anders to approve it. For filling in docs on things
that have already been decided, any PM on the team can give the LGTM.

## When are we going to open the process up to the public?

Before we can go live, we want to get some feedback and iterate on the documentation in the repo and make sure that's all in good shape and we're happy with it.

We also want to have a couple of DEPs already in the pipeline. That will let people see how the process works. For those who want to write their own proposals, it will give them concrete examples to learn from and get a sense of what a good DEP looks like.

Most of the DEP committee will be in Mountain View later this month for the TC 52 meeting anyway, so we'll aim to launch it after that. We're looking at **Feb 26th** to make the repo public and announce it on the site.

By then, the docs should be solid, and we should have two DEPs that we'd have some time to crank on in a couple of meetings.

The tear-off proposal is already in pretty good shape, so that should be straightforward. The other proposal might make sense to be rolled into that one, or maybe it should be a separate one that starts off a little barebones. We'll just see how the first goes and take it from there.

## Meeting notes

More administrivia about take meeting notes. I'll spare you the details so you don't fall asleep reading them.

## Summary

We're really excited to get this process up and running. People will get to see what changes are happening and what they're status is. They'll be able to participate, and everything will be more transparent.

## DEP repos

We talked about the proposed workflow where each DEP lives in its own repo. In our repo, we'll maintain an open tracking issue for each DEP. That issue uniquely identifies the proposal. The label on the issue defines the status of that proposal.

This means you can do a simple query on the dart_enhancement_proposals issue tracker to see what the status of every DEP is.

We'll give this workflow a try and see how it goes.

## [TLA][]

There was some discussion about changing this from "DIP" to "DEP". We originally called these "Dart *Improvement* Proposals". But "improvement" might carry a connotation that the current Dart isn't quite so good. More importantly, "dip" has negative connotations in the US meaning a somewhat-intellectually-challenged person.

Thus: Dart *Enhancement* Proposals. "DEP" can also be used to mean "dependency", but we think it will be clear which one is being referred to in context.

[tla]: http://en.wikipedia.org/wiki/Three-letter_acronym