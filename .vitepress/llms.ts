/**
 * Machine-readable docs: an llms.txt index, and the markdown behind every page.
 *
 * An assistant asked about one of these resources currently has two options,
 * and both are bad. It can fetch the rendered HTML and read a VitePress theme —
 * nav, sidebar, search widget, footer — around a few hundred words of actual
 * answer. Or it can guess. Meanwhile the real content is already markdown in
 * this repository and was converted to HTML for the sole benefit of people.
 *
 * So this hands back what was there all along:
 *
 *   /llms.txt                                   an index of every page
 *   /resources/shops/installation.md            the markdown behind one page
 *
 * The rule is deliberately boring — the markdown for any page is that page's
 * path with `.md` on the end — because a convention an agent can guess without
 * being told beats one it has to be taught. Section landing pages keep their
 * `index.md`, matching the file that produces them.
 *
 * WHY buildEnd AND NOT public/. Writing these into `public/` would work and
 * would put 156 generated files under version control, where they would drift
 * from their sources the first time someone edited a page and did not rerun the
 * generator. Written here, into the build output, they cannot drift: they are
 * produced from the sources every single build, and there is nothing to commit.
 *
 * There is no llms-full.txt. The convention suggests one — every page
 * concatenated — and at 1.1MB across 156 files it would be roughly 280k tokens,
 * too large for the context of the thing meant to read it, and it would be
 * fetched in full to answer a question about one config option. The index plus
 * one page is the same information at a thousandth of the cost.
 */
import fs from "node:fs";
import path from "node:path";

interface SidebarItem {
  text?: string;
  link?: string;
  items?: SidebarItem[];
}

/** Frontmatter title and description, without pulling in a YAML parser. */
function readFrontmatter(source: string): { title?: string; description?: string; body: string } {
  if (!source.startsWith("---")) return { body: source };
  const end = source.indexOf("\n---", 3);
  if (end === -1) return { body: source };

  const head = source.slice(3, end);
  const body = source.slice(end + 4).replace(/^\r?\n/, "");
  const field = (name: string) => {
    // Values here are plain scalars — titles and one-line descriptions — so a
    // line match is enough and a YAML dependency is not.
    const m = head.match(new RegExp(`^${name}:\\s*(.+)$`, "m"));
    return m ? m[1].trim().replace(/^["']|["']$/g, "") : undefined;
  };
  return { title: field("title"), description: field("description"), body };
}

/** Every .md under the docs root, as repo-relative paths. */
function markdownFiles(root: string): string[] {
  const out: string[] = [];
  const skip = new Set(["node_modules", ".vitepress", ".git", "public", "dist"]);

  const walk = (dir: string) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      if (entry.isDirectory()) {
        if (!skip.has(entry.name)) walk(path.join(dir, entry.name));
      } else if (entry.name.endsWith(".md")) {
        out.push(path.relative(root, path.join(dir, entry.name)).split(path.sep).join("/"));
      }
    }
  };
  walk(root);
  return out.sort();
}

/** `resources/shops/installation.md` -> `/resources/shops/installation` */
function routeFor(file: string): string {
  const noExt = file.replace(/\.md$/, "");
  if (noExt === "index") return "/";
  return "/" + noExt.replace(/\/index$/, "/");
}

/**
 * The index, built from the sidebar rather than the file tree.
 *
 * The file tree knows what exists; the sidebar knows how it is meant to be
 * read — which resource a page belongs to, what it is called, and the order a
 * human was intended to meet it in. Reproducing that grouping is the whole
 * value of the index over a directory listing, so pages the sidebar never
 * mentions are appended at the end rather than silently dropped.
 */
function buildIndex(
  root: string,
  sidebar: SidebarItem[],
  meta: Map<string, { title?: string; description?: string }>,
): string {
  const seen = new Set<string>();
  const lines: string[] = [];

  const emit = (items: SidebarItem[], depth: number) => {
    for (const item of items) {
      const indent = "  ".repeat(depth);
      if (item.link) {
        const key = item.link.replace(/\/$/, "") || "/";
        seen.add(key);
        const info = meta.get(key) ?? {};
        const title = item.text ?? info.title ?? item.link;
        const suffix = info.description ? `: ${info.description}` : "";
        lines.push(`${indent}- [${title}](${item.link})${suffix}`);
      } else if (item.text) {
        lines.push(`${indent}- ${item.text}`);
      }
      if (item.items?.length) emit(item.items, item.link || item.text ? depth + 1 : depth);
    }
  };

  for (const section of sidebar) {
    if (section.text) lines.push(`\n## ${section.text}\n`);
    emit(section.items ?? [], 0);
  }

  const orphans = [...meta.entries()].filter(([route]) => !seen.has(route.replace(/\/$/, "") || "/"));
  if (orphans.length) {
    lines.push(`\n## Other pages\n`);
    for (const [route, info] of orphans.sort()) {
      lines.push(`- [${info.title ?? route}](${route})${info.description ? `: ${info.description}` : ""}`);
    }
  }

  return `# Samuel's Development — documentation

> Documentation for Samuel's Development FiveM resources: installation,
> configuration, exports and hooks for each script. Scripts are sold at
> https://fivem.samueldev.shop and supported at https://discord.gg/FzPehMQaBQ.

The markdown source of any page below is that page's path with \`.md\` appended
— \`/resources/shops/installation\` is at \`/resources/shops/installation.md\`.
Section landing pages keep \`index.md\`: \`/resources/shops/\` is at
\`/resources/shops/index.md\`. Fetch those rather than the HTML; they are the
same content without the theme around it.
${lines.join("\n")}
`;
}

/**
 * Write llms.txt and one .md per page into the build output.
 *
 * Called from `buildEnd` in config.ts. Throwing here would fail the build, and
 * a docs deploy should not die because a generated convenience file could not
 * be written — so problems are logged and the build carries on without them.
 */
export function writeLlmsFiles(root: string, outDir: string, sidebar: SidebarItem[]): void {
  try {
    const files = markdownFiles(root);
    const meta = new Map<string, { title?: string; description?: string }>();

    for (const file of files) {
      const source = fs.readFileSync(path.join(root, file), "utf8");
      const { title, description, body } = readFrontmatter(source);
      const route = routeFor(file);
      meta.set(route.replace(/\/$/, "") || "/", { title, description });

      /*
       * A heading naming the page and its route, then the body. The route is
       * in the file because these are fetched individually and out of context:
       * an agent handed a wall of markdown should be able to cite where it
       * came from without having to remember what it asked for.
       *
       * The body's own leading `# Title` is absorbed rather than left in
       * place. Most pages carry one, and printing it under a synthetic heading
       * of the same name produced two H1s and read as though the content had
       * been pasted in twice. Where a page has no frontmatter title, that
       * heading is the best title available, so it is promoted rather than
       * discarded.
       */
      const trimmed = body.replace(/^\s+/, "");
      const leadingH1 = trimmed.match(/^#\s+(.+?)\s*$/m);
      const hasLeadingH1 = trimmed.startsWith("#") && !trimmed.startsWith("##");
      const shown = title ?? (hasLeadingH1 ? leadingH1?.[1] : undefined);
      const rest = hasLeadingH1 ? trimmed.replace(/^#\s+.+?\r?\n/, "").replace(/^\s+/, "") : trimmed;

      const heading = shown ? `# ${shown} (${route})\n\n` : `# ${route}\n\n`;
      const target = path.join(outDir, file);
      fs.mkdirSync(path.dirname(target), { recursive: true });
      fs.writeFileSync(target, heading + rest, "utf8");
    }

    fs.writeFileSync(path.join(outDir, "llms.txt"), buildIndex(root, sidebar, meta), "utf8");
    console.log(`[llms] wrote llms.txt and ${files.length} markdown pages`);
  } catch (error) {
    console.warn("[llms] skipped:", error);
  }
}
