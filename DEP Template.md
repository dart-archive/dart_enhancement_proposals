# Proposal name

The name of your proposal. Make it brief but unambiguous. We will be referring to it in hallway conversations, email, comment threads, and likely in our dreams, so make it snappy but try to spare the buzzwords and marketing.

## Contact information

Three key pieces of information are required:

1. **Your name.** As the author, you are signing up to shepherd this proposal through the process. (A proposal *can* be passed on to someone else if really needed, but at any point in time, it must have a living breathing owner who actively cares about it.)

2. **Your contact information.** Email address at a bare minimum. A GitHub account is good too.

3. **The repository where this proposal and its associated artifacts lives.** At first, this document will live *in* that repo, so it's kind of implicit. But, when the proposal is approved, the text will be migrated into the canonical repository for completed DEPs. At that point, we want it to point out to the original repo so readers can find the other artifacts, history, and discussion.

In addition, a list of other stakeholders is good. These are people who have a vested interest and relevant expertise in the proposal. Good stakeholders are ones who:

- Own important Dart applications or frameworks.
- Are acutely feeling the pain this proposal addresses.
- Can provide clear, articulate feedback.

Names, email, and GitHub accounts if they have them.

## Summary

A brief description of the proposal. Think a couple of sentences or
a short paragraph. Maybe a small snippet of code or example.

## Motivation

This is in many ways the most important section. It motivates the reader to care about the problems or shortcomings this proposal addresses. The language specification and the language committee are both finite resources. Tell us why we should spend them on this issue instead of others.

Describe in detail the existing problems or use cases this proposal addresses. A use case is more compelling when:

- It affects a large number of users.
- These users are writing real-world programs.
- It's difficult or impossible to workaround the problems.

In other words, the ideal motivation is a problem that's preventing every Dart user from shipping their app.

## Examples

Now that you've hopefully sold us caring about the problem, show us your solution. We'll get into the general behavior soon, but first, walk us through a few realistic examples of how the proposal would be used in practice.

Humans tend to absorb information better if you start with examples and then show the general principle, so this is the place for your proposal's highlight reel. It gives us readers a chance to develop and intuition for what your proposal does and get a feel for its user experience.

Try to use real-world examples. Keep them small, but with realistic context. "Foo" and "bar" make it hard to evaluate how the proposal would look in real code.

## Proposal

At this point, we should care about your problem and think your solution looks beautiful. Now it's time to dig in and explain how it works in detail. Cover the syntax and semantics precisely and clearly.

Describe its behavior in common usage, but also how it acts in bizarre corner cases. You don't need to be as precise as actual language spec verbiage, but this is the place where you start heading in that direction.

This is probably the least fun, but ultimately the most important section.

## Alternatives

While you may think of your solution as a perfect snowflake, there are other pretty snowflakes out there. Describe alternate solutions that cover the same space as this proposal. Compare them to the proposal and each other and explain why they were rejected.

What advantages do these alternatives have that the chosen one lacks? What does the selected proposal offer to outweigh them? Being rigorous here shows that you've done your due diligence and fully explored both the problem and the potential solution space. We want to be confident that we have not just *a* solution to the problem, but the *best* one.

## Implications and limitations

A good language is a cohesive whole. Even a small, well-defined proposal still has to hang together with the rest of the Dart platform.

- How does this feature interact with the other language features&mdash;in both good and bad ways&mdash;?
- If we adopt this feature what will it prevent us from doing now? What do we sacrifice for this?
- How does it affect the future evolution of the language?

## Deliverables

These don't have to be done *initially* but before the proposal can be given the final stamp of approval before it's shipped off to TC 52, three key artifacts are required.

These will live in the same repo as your proposal.

### Language specification changes

These the actual, precise diffs for how the [language spec][] will be modified.
Time to brush up on your [TeX][]. Being able to do this well is a rare gift, so
you are not expected to be a spec wizard. Fortunately, we have a couple on
staff. Do your best and as your proposal matures, we will help.

### A working implementation

Nothing flushes out the problems with a feature quite like writing it in cold, hard executable code. Before a proposal can be approved, some kind of working implementation must be provided.

Again, you don't have to have this on day one. However, you should make as much progress on this as early as you can. You *are* expected to be able to write working code, so there's nothing really holding you back. Doing this before you show your proposal to the world is a good sanity check to ensure you don't propose something that turns out to be impossible to implement. (It happens to the best of us.)

It's not necessary to actually implement your feature in the native Dart VM or dart2js compiler (though you can and will certainly get street cred for doing so). Instead, you may:

* Write some sort of standalone prototype implementation.
* Write a [transpiler][] that takes Dart code using your feature and translates it to "vanilla" Dart code.

What matters is that you demonstrate that the feature can feasibly be implemented in a reasonable amount of code with good performance.

### Tests

Write tests that could be run under an implementation to determine if it implements your proposal correctly. Make sure to test both success and failure cases. Be thorough. Programming languages have combinatorial input, so defining a comprehensive test suite is difficult.

Imagine an adversary is going to write a malicious implementation of your proposal that passes its tests but otherwise does things so horrible it will cause the language team to run screaming from your proposal. Don't let the adversary win.

## Patents rights

TC52, the Ecma technical committee working on evolving the open [Dart standard][], operates under a royalty-free patent policy, [RFPP][] (PDF). This means if the proposal graduates to being sent to TC52, you will have to sign the Ecma TC52 [external contributer form][] and submit it to Ecma.

[tex]: http://www.latex-project.org/
[language spec]: https://www.dartlang.org/docs/spec/
[dart standard]: http://www.ecma-international.org/publications/standards/Ecma-408.htm
[rfpp]: http://www.ecma-international.org/memento/TC52%20policy/Ecma%20Experimental%20TC52%20Royalty-Free%20Patent%20Policy.pdf
[external contributer form]: http://www.ecma-international.org/memento/TC52%20policy/Contribution%20form%20to%20TC52%20Royalty%20Free%20Task%20Group%20as%20a%20non-member.pdf
