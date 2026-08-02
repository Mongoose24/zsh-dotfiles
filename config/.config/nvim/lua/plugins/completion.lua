local tools = require("config.tools")
local has_build_tools = tools.executable("make") and tools.has_compiler()

local appearance = { nerd_font_variant = "mono" }
if not vim.g.have_nerd_font then
	appearance.kind_icons = {
		Text = "txt",
		Method = "method",
		Function = "fn",
		Constructor = "new",
		Field = "field",
		Variable = "var",
		Class = "class",
		Interface = "interface",
		Module = "module",
		Property = "property",
		Unit = "unit",
		Value = "value",
		Enum = "enum",
		Keyword = "keyword",
		Snippet = "snippet",
		Color = "color",
		File = "file",
		Reference = "ref",
		Folder = "dir",
		EnumMember = "member",
		Constant = "const",
		Struct = "struct",
		Event = "event",
		Operator = "operator",
		TypeParameter = "type",
	}
end

return {
	{
		"saghen/blink.cmp",
		branch = "v1",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = has_build_tools and "make install_jsregexp" or nil,
			},
		},
		opts = {
			keymap = { preset = "default" },
			appearance = appearance,
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},
}
