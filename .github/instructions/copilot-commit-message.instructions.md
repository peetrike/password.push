# Copilot instructions for commit messages

Follow the Conventional Commits format strictly for commit messages.
Use the structure below:

```
<type>[optional scope][!]: <gitmoji> <description>

[optional body]

[optional footer(s)]
```

Guidelines:

1. **Type and Scope**: Use one of these types: `feat`, `fix`, `docs`,
   `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, or `revert`.
   Include an optional scope to describe the affected module or feature.
2. **Gitmoji**: Use gitmojis from gitmoji.dev. Use `feat` -> `✨`, `fix` ->
   `🐛`, `docs` -> `📝`, `style` -> `🎨`, `refactor` -> `♻️`, `perf` -> `⚡️`,
   `test` -> `✅`, `build` -> `📦`, `ci` -> `👷`, `chore` -> `🔧`, and
   `revert` -> `⏪`.
3. **Description**: Write a concise, informative description in the header;
   it must be lowercase, imperative (for example, `add` rather than `added`),
   contain no trailing period, and be no more than 72 characters.
4. **Body**: For additional details, use a well-structured body section:
   - Use bullet points (`*`) for clarity.
   - Clearly describe the motivation, context, or technical details behind
     the change, if applicable.
5. **Breaking Changes**: Append `!` after the type or scope (for example,
   `feat(api)!:`) and include a `BREAKING CHANGE: <description>` footer that
   explains the impact and migration path.

Commit messages should be clear, informative, and professional,
aiding readability and project tracking.
