<picture>
  <source media="(prefers-color-scheme: dark)" srcset="package/logo-dark.svg">
  <img src="package/logo.svg" alt="Agentation" width="200">
</picture>

<br>

[![npm version](https://img.shields.io/npm/v/agentation)](https://www.npmjs.com/package/agentation)
[![downloads](https://img.shields.io/npm/dm/agentation)](https://www.npmjs.com/package/agentation)

**[Agentation](https://agentation.com)** is an agent-agnostic visual feedback tool. Click elements on your page, add notes, and copy structured output that helps AI coding agents find the exact code you're referring to.


## Consommer ce fork

```json
{
  "trustedDependencies": ["agentation"],
  "devDependencies": {
    "agentation": "github:Digital-Kickoff-Labs/agentation#main"
  }
}
```

Le dépôt est un monorepo pnpm et le paquet vit dans `package/`, alors que npm, bun et yarn
installent une dépendance git depuis la **racine**. La racine expose donc `main`, `module`,
`types` et `exports` vers `package/dist`, et un script `prepare` construit le paquet à
l'installation quand `dist` est absent — c'est-à-dire chez le consommateur après le clone
git, jamais chez quelqu'un qui vient de construire ici.

`trustedDependencies` est obligatoire côté consommateur : bun bloque les scripts de cycle de
vie par défaut, et sans cette ligne l'installation réussit en silence avec un paquet vide.

`prepare` appelle bun. Un développeur du dépôt qui installe avec pnpm et n'a pas bun verra
donc l'étape échouer ; construire une fois à la main (`cd package && pnpm build`) suffit à
la désarmer, puisqu'elle ne se déclenche que si `dist` manque.

## Install

```bash
npm install agentation -D
```

## Usage

```tsx
import { Agentation } from 'agentation';

function App() {
  return (
    <>
      <YourApp />
      <Agentation />
    </>
  );
}
```

The toolbar appears in the bottom-right corner. Click to activate, then click any element to annotate it.

## Features

- **Click to annotate** – Click any element with automatic selector identification
- **Text selection** – Select text to annotate specific content
- **Multi-select** – Drag to select multiple elements at once
- **Area selection** – Drag to annotate any region, even empty space
- **Animation pause** – Freeze all animations (CSS, JS, videos) to capture specific states
- **Structured output** – Copy markdown with selectors, positions, and context
- **Dark/light mode** – Matches your preference or set manually
- **Zero dependencies** – Pure CSS animations, no runtime libraries

## How it works

Agentation captures class names, selectors, and element positions so AI agents can `grep` for the exact code you're referring to. Instead of describing "the blue button in the sidebar," you give the agent `.sidebar > button.primary` and your feedback.

## Requirements

- React 18+
- Desktop browser

For Expo / React Native apps, use
[`agentation-native`](https://github.com/Digital-Kickoff-Labs/agentation-native):
same annotation protocol and same MCP server, native capture layer.

## Docs

Full documentation at [agentation.com](https://agentation.com)

## License

© 2026 Benji Taylor

Licensed under PolyForm Shield 1.0.0
