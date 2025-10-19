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
  s(
    "fn",
    fmt(
      [[function {}({}) {{
    {}
  }}]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    "story",
    fmt(
      [[import type {{ Meta, StoryObj }} from '@storybook/{}';
import {{ {component} }} from './{component}';
 
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
        i(3), -- props
        i(4, "Primary"), -- variant name
        i(5),
      },
      {
        repeat_duplicates = true,
      }
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
  s("spdx", fmt([[// SPDX-License-Identifier: {}]], {
    c(1, {
      t("UNLICENSED"),
      t("MIT"),
      t("BUSL-1.1"),
      t("CC-BY-3.0-US"),
    }),
  })),
  s("pragma", fmt([[pragma solidity {};]], {
    c(1, {
      t("0.8.30"),
      t("0.8.29"),
    })
  })),
  s("im", fmt([[import {{ {} }} from "{}";]], {
    i(1),
    i(2),
  })),
  s("ae", fmt([[assertEq({});]], {
    i(1),
  })),
  s("console", fmt([[console.log({});]], {
    i(1),
  })),
})
