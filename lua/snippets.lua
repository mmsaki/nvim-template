local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

ls.filetype_extend("javascript", { "typescript" })
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend(
  "javascriptreact",
  { "typescriptreact", "javascript", "typescript" }
)
ls.filetype_extend(
  "typescriptreact",
  { "javascriptreact", "typescript", "javascript" }
)

ls.add_snippets("typescript", {
  s("fn", fmt([[function {}({}) {{ {} }}]], { i(1), i(2), i(3) })),
  s("ec", fmt([[export const {} = {};]], { i(1), i(2) })),
  s("map", fmt([[{}.map(({}) => {{ {} }})]], { i(1), i(2), i(3) })),
  s("c", fmt([[const {} = {};]], { i(1), i(2) })),
  s(
    "et",
    fmt(
      [[export type {} = {} {};]],
      { i(1), c(2, { t("keyof"), t("typeof") }), i(3) }
    )
  ),
  s(
    "im",
    fmt([[import {} from "{}";]], {
      c(1, {
        fmt("{{ {} }}", { i(1) }),
        fmt("{}", { i(1) }),
      }),
      i(2),
    })
  ),
  s(
    "story",
    fmt(
      [[import type {{ Meta, StoryObj }} from '@storybook/{}';
import {{ {component} }} from '@/{}/{component}';
 
const meta = {{
  title: "components/{component}",
  component: {component},
  args: {{{}}},
}} satisfies Meta<typeof {component}>;
 
export default meta;
type Story = StoryObj<typeof meta>;
 
export const {}: Story = {{
  args: {{
    {}
  }},
}};]],
      {
        c(1, {
          t("nextjs"),
          t("nextjs-vite"),
          t("react-vite"),
        }),
        component = i(2), -- import name
        i(3),
        i(4), -- props
        i(5, "Primary"), -- variant name
        i(6),
      },
      {
        repeat_duplicates = true,
      }
    )
  ),
  s(
    "switch",
    fmt(
      [[switch ({}) {{
    case {}:
      {}
      break;
    case {}:
      {}
      break;
    default:
      {}
  }}]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
      }
    )
  ),
})

ls.add_snippets("typescriptreact", {
  s("div", fmt([[<div {}>{}</div>]], { i(1), i(2) })),
  s("p", fmt([[<p {}>{}</p>]], { i(1), i(2) })),
  s("a", fmt([[<a {}>{}</a>]], { i(1), i(2) })),
  s(
    "button",
    fmt(
      [[<button type="{}" {}>{}</button>]],
      { c(1, { t("button"), t("submit") }), i(2), i(3) }
    )
  ),
  s("canvas", fmt([[<canvas {}>{}</canvas>]], { i(1), i(2) })),
  s("span", fmt([[<span {}>{}</span>]], { i(1), i(2) })),
  s("body", fmt([[<body {}>{}</body>]], { i(1), i(2) })),
  s("h1", fmt([[<h1 {}>{}</h1>]], { i(1), i(2) })),
  s("h2", fmt([[<h2 {}>{}</h2>]], { i(1), i(2) })),
  s("h3", fmt([[<h3 {}>{}</h3>]], { i(1), i(2) })),
  s("h4", fmt([[<h4 {}>{}</h4>]], { i(1), i(2) })),
  s("h5", fmt([[<h5 {}>{}</h5>]], { i(1), i(2) })),
  s("h6", fmt([[<h6 {}>{}</h6>]], { i(1), i(2) })),
  s("li", fmt([[<li {}>{}</li>]], { i(1), i(2) })),
  s("ol", fmt([[<ol {}>{}</ol>]], { i(1), i(2) })),
  s("ul", fmt([[<ul {}>{}</ul>]], { i(1), i(2) })),
  s("abbr", fmt([[<abbr {}>{}</abbr>]], { i(1), i(2) })),
  s("acronym", fmt([[<acronym title="{}" {}>]], { i(1), i(2) })),
  s("address", fmt([[<address {}>{}</address>]], { i(1), i(2) })),
  s("article", fmt([[<article {}>{}</article>]], { i(1), i(2) })),
  s("aside", fmt([[<aside {}>{}</aside>]], { i(1), i(2) })),
  s("audio", fmt([[<audio src="{}">{}</audio>]], { i(1), i(2) })),
  s(
    "blockquote",
    fmt([[<blockquote cite="{}">{}</blockquote>]], { i(1), i(2) })
  ),
  s("b", fmt([[<b {}>{}</b>]], { i(1), i(2) })),
  s(
    "area",
    fmt(
      [[<area shape="{}" coords="{}" href="{}" alt="{}">{}</area>]],
      { i(1), i(2), i(3), i(4), i(5) }
    )
  ),
  s("hr", fmt([[<hr {}>]], { i(1) })),
  s("br", fmt([[<br {}/>]], { i(1) })),
  s("class", fmt([[className="{}"]], { i(1) })),
  s(
    "style",
    fmt(
      [[style={{{{
  {}
  }}}}]],
      { i(1) }
    )
  ),
})

ls.add_snippets("css", {
  s(
    "@prefer",
    fmt("@media (prefers-color-scheme: {}) {{\n\t:root {{\n\t\t{}\n\t}}\n}}", {
      c(1, {
        t("light"),
        t("dark"),
      }),
      i(2),
    })
  ),
  s("im", fmt([[@import "./{}";]], { i(1) })),
  s(
    "@theme",
    fmt(
      [[
  @theme {{
    {}
  }}]],
      {
        i(1),
      }
    )
  ),
})

ls.add_snippets("lua", {
  s(
    "var",
    fmt([[local {} = {}]], {
      i(2),
      i(1),
    })
  ),
})

ls.add_snippets("solidity", {
  s(
    "spdx",
    fmt([[// SPDX-License-Identifier: {}]], {
      c(1, {
        t("UNLICENSED"),
        t("MIT"),
        t("BUSL-1.1"),
        t("CC-BY-3.0-US"),
      }),
    })
  ),
  s(
    "pragma",
    fmt([[pragma solidity {};]], {
      c(1, {
        t("0.8.30"),
        t("0.8.29"),
      }),
    })
  ),
  s(
    "im",
    fmt([[import {{ {} }} from "{}";]], {
      i(1),
      i(2),
    })
  ),
  s(
    "ae",
    fmt([[assertEq({});]], {
      i(1),
    })
  ),
  s(
    "console",
    fmt([[console.log({});]], {
      i(1),
    })
  ),
})

ls.add_snippets("python", {
  s(
    "im",
    fmt([[from {} import {}]], {
      i(1),
      i(2),
    })
  ),
})
