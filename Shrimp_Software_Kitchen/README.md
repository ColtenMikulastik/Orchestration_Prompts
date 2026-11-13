# Prompts v2

Two kitchens share one designer. Pick one when you start the build phase. The old prompts (the top-level `*.md` files and `work_folder/prompts/`) are untouched and can be ignored.

Paths inside these prompts are relative to `prompts-v2/`.

## Layout

```
Shrimp_Kitchen/
├── common/
│   ├── designer.md        design phase, both kitchens (unchanged from before)
│   └── herdr.md           how to run agents in herdr, both kitchens
├── gourmet/               Shrimp Gourmet Kitchen (test-driven)
│   ├── orchestrator.md
│   ├── tester.md          writes visible and hidden tests per task
│   ├── evaluator.md       checks red, then judges each build
│   └── tooler.md
└── fast-food/             Shrimp Fast Food Kitchen (quick)
    ├── orchestrator.md
    ├── tester.md          writes one test suite, then judges every task
    └── tooler.md
```

## The two kitchens

**Shrimp Gourmet Kitchen** is test-driven. Each task gets its own tests before any code exists. A separate evaluator agent checks the tests are red, and checks the build afterwards. Hidden tests live outside the repo. Use it for production-quality code.

**Shrimp Fast Food Kitchen** is quick. One test suite is written once, from the design, before the build. The same tester then judges each task. There are no hidden tests. Use it for prototypes and anything where speed matters more than a strict check. The trade-off is that the suite is a weaker check on the code than the Gourmet kitchen's tests.

## How to run either kitchen

1. **Design.** In a herdr pane, start a conversation with `common/designer.md` as the instructions. Talk the project through, including the language and test framework. It writes `design/`. Confirm when you're happy.
2. **Stack.** The `design/stack.md` file must have a check command, a command for running tests in a given directory (Gourmet only), and the test runner's per-test timeout. Ask the designer to add anything missing.
3. **Hidden tests (Gourmet only).** Pick a folder outside the repo for them, and make sure the test runner can run tests from there.
4. **Start the orchestrator.** In a fresh herdr pane, start a conversation with `gourmet/orchestrator.md` or `fast-food/orchestrator.md` as the instructions. Tell it where the hidden tests folder is (Gourmet only). It plans and writes `tasks.md`, tells you which agent kinds it will use, and waits for your approval before it runs anything.
5. **Watch the herd.** Each task gets its own herdr tab, labelled with the task ID. Agents are named `<role>-<task>`, for example `tester-t7` or `tooler-t7`. A blocked pane is waiting on a question or an approval. The orchestrator answers questions about the task, and for permission prompts it tells you which pane to look at.
6. **Handle git yourself.** The orchestrator tells you when a task is done and it's a good moment to commit.

To redesign, reopen the designer with `design/` in place, then tell the orchestrator the design changed.

## Limits (defaults, set in each orchestrator)

- 300 seconds per test run, with the command wrapped in `timeout`.
- One extra wait after a timeout, then the orchestrator stops and tells you which pane is stuck.
- 45 minutes per task, then the orchestrator asks you whether to continue.
- At most two agent panes open per task.
- Retry cap of 3 rounds per failure.

## Known limits

- Hidden tests (Gourmet) are a soft barrier. The tooler is told to stay inside the project directory, but nothing technically stops an agent with file access from looking around.
- The herdr commands are checked against `herdr --help` as of this version. The herdr server wasn't running when they were checked, so the output shapes (for example the pane id returned by `herdr tab create`) must be confirmed on the first run. The orchestrator is told to check and adapt.
- Fast Food's tester keeps its context for the whole run, so it grows. The orchestrator can replace it when it gets vague.
