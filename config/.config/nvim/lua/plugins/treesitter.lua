local parsers = {
  "bash",
  "c",
  "diff",
  "html",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
}

local treesitter = require("nvim-treesitter")
treesitter.install(parsers)

local function attach(buf, language)
  if not vim.treesitter.language.add(language) then
    return
  end

  vim.treesitter.start(buf, language)

  if vim.treesitter.query.get(language, "indents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local available = treesitter.get_available()
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    local language = vim.treesitter.language.get_lang(event.match)
    if not language then
      return
    end

    local installed = treesitter.get_installed("parsers")
    if vim.tbl_contains(installed, language) then
      attach(event.buf, language)
    elseif vim.tbl_contains(available, language) then
      treesitter.install(language):await(function()
        attach(event.buf, language)
      end)
    else
      attach(event.buf, language)
    end
  end,
})
