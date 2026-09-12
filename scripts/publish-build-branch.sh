#!/usr/bin/env bash
# Publie la branche `build` : le contenu de `package/` à la racine, `dist/` compris.
#
# Pourquoi elle existe. Ce dépôt est un monorepo pnpm et le paquet vit dans
# `package/`. Or npm, bun et yarn installent une dépendance git depuis la
# RACINE du dépôt : pointer sur ce fork tel quel installe le monorepo, sans
# `dist`, donc rien d'utilisable. Aucun gestionnaire ne sait cibler un
# sous-dossier de façon portable.
#
# La branche `build` est donc le paquet, prêt à consommer :
#
#   "agentation": "github:Digital-Kickoff-Labs/agentation#build"
#
# Elle est jetable et régénérée par ce script — ne jamais y committer à la main.
# Le jour où le paquet est publié sur npm, elle disparaît.
set -euo pipefail

racine="$(cd "$(dirname "$0")/.." && pwd)"
cd "$racine"

source_sha="$(git rev-parse --short HEAD)"
branche_source="$(git rev-parse --abbrev-ref HEAD)"

echo "→ Construction depuis $branche_source ($source_sha)"
cd package
[ -d node_modules ] || bun install --silent
bun run build
cd "$racine"

etape="$(mktemp -d)"
trap 'rm -rf "$etape"' EXIT

# `dist` est ignoré dans le dépôt source ; sur la branche `build` c'est
# justement ce qu'on publie, d'où le .gitignore réduit.
cp -r package/. "$etape/"
rm -rf "$etape/node_modules" "$etape/example" "$etape/.next"
printf 'node_modules/\n' > "$etape/.gitignore"

cd "$etape"
git init -q
git add -A
git -c user.name="$(git -C "$racine" config user.name)" \
    -c user.email="$(git -C "$racine" config user.email)" \
    commit -q -m "Build du paquet depuis $branche_source ($source_sha)"
git push -q --force "https://github.com/Digital-Kickoff-Labs/agentation.git" HEAD:build

echo "✓ Branche build publiée depuis $source_sha"
