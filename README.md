# Why a “Dart Enhancement Proposal” process?

We want to create a more open, collaborative, and inclusive Dart ecosystem.
We want Dart to be responsive to developer requirements.
We want to encourage the community to feel a shared sense of ownership and stewardship.
We want to be more transparent about the work leading up to Dart language changes. I.e., we want to

1. ensure rationale behind changes (or decisions not to change) is clearly communicated to the Dart community.
2. "close the loop" and ensure that stakeholders are satisfied with a solution before it gets locked down.
3. lean some of the burden of due diligence on the proposer to make effective use of the language team's time.

We want to be clear about how developers can make a proposal for a language change.

TC52 always has the final say in whether a proposal gets accepted or rejected. The DEP committee is approved and tasked by TC52 to manage the inflow of proposals for discussion. Moreover, TC52 members can always bring proposals in as they please because that is inherent in the standards process.

# Dart Enhancement Proposal Flow

![DEP Flow](https://drive.google.com/file/d/0B9dMunGq8GTZUW1KdTJocUM0a0U/view?usp=sharing)

Blue boxes are controlled by the author, and green boxes are controlled by the DEP committee. Dark boxes are states a proposal can be in and light rounded boxes are actions the people can take.

- An idea for improving Dart begins as a rough **concept**. Authors are strongly encouraged to share their idea with the ecosystem before filling out the full DEP template. This ensures they don’t waste time on ideas that have already been considered before or are infeasible or unlikely to succeed.
- If the ecosystem likes the concept, the author **writes a DEP document**. The proposal is now a **draft**.
- Once the community is happy with the DEP document, the author can **propose to committee** that the DEP is considered. This is done by filing an issue on dartbug.com using the “Dart Enhancement Proposal” template.
- The DEP committee convenes and reviews any proposed drafts. For each DEP, they will either **dismiss** it, **give feedback**, or **promote** it.
- If the committee finds that the proposed DEP isn’t likely to ever become relevant, it may be **dismissed**. This is to weed out spurious or ill-conceived ideas, or problems that already have a good solution.
- If the committee thinks the idea has merit, but the draft isn’t ready for TC 52 they will **give feedback** to the author. This bounces it back to the **draft** state until the author makes changes.
- The author makes any relevant changes or additions and then **proposes it again** for another round of review but updating the issue. Multiple cycles of this may occur, though everyone naturally wants to minimize this. The committee will then review it again at the next meeting.
- If the committee is in favor of the DEP becoming an actual change to the language, they will **promote** it. This doesn’t carve it in stone. The proposal then goes to ECMA TC 52 and the expectation here is that the proposal is likely to move forward.
- At any point in time, the author may **abandon** their proposal and not proceed with the DEP. This may because they found a better way to solve their problem, or another DEP superseded it or the author simply doesn’t have the time to work on it or find someone else to take the helm.

# DEP committee review meetings

Periodically, the DEP committee meets to determine the disposition of active DEPs.

For each active DEP, the outcome is either
- Feedback to revise
- Promote to recommend TC52 to look at it
- Dismiss

A DEP is active iff it is either newly submitted or awaits more work as a result of feedback to revise. It’s the committee’s job to explain what further work is needed—owner may be asked to participate in the meeting.

The review meetings are held approximately every 2-4 weeks - depending on demand. Schedule is expected (TODO:Link to schedule). We will publish minutes and decision summaries from each meeting.

Current members of the DEP committee are: Lars Bak, Kasper Lund, Gilad Bracha, Bob Nystrom, Lasse Reichstein Nielsen, and Anders Thorhauge Sandholm. We may also decide to include additional non-Google employee members.

# How do I submit a proposal?

- Check on the mailing list, issue tracker, etc. to see if someone already made the proposal, if there is interest.
- Develop your proposal and start work on a DEP document and potentially a prototype implementation
- Once you’ve floated the idea informally with the community, e.g., mailing list, Dartisans on G+ and you’re happy with the proposal, you’re ready to formally submit the proposal. prototype and clear about the semantics of the new feature, start filling out the DEP template.
- Submit proposal
  - Make a copy of “DEP for <new feature> template” (essentially a markdown file with the below template).
  - Fill in the doc with contents
  - File an issue on the DEP github repo
    - Fill in the link to your DEP doc (this should be changed into a PR taking a markdown file???)
    - Fill in the link to the repo with the implementation if you have one already.
