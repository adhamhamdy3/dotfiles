local function switch_source_header(bufnr)
	local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
	if not client then return vim.notify("clangd not attached") end
	local params = vim.lsp.util.make_text_document_params(bufnr)
	client:request("textDocument/switchSourceHeader", params, function(err, result)
		if err or not result then return vim.notify("No corresponding file") end
		vim.cmd.edit(vim.uri_to_fname(result))
	end, bufnr)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local function map(keys, fn, desc, mode)
			vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = desc })
		end
		local tb = function(name) return function() require("telescope.builtin")[name]() end end

		-- Navigation (same as VS Code F12 / Shift+F12)
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("<F12>", vim.lsp.buf.definition, "Go to definition")
		map("gD", vim.lsp.buf.declaration, "Go to declaration")
		map("<S-F12>", tb("lsp_references"), "References (Telescope)")
		map("<leader>fr", tb("lsp_references"), "Find all references")

		-- Peek
		map("gp", "<cmd>Glance definitions<cr>", "Peek definition")
		map("gpr", "<cmd>Glance references<cr>", "Peek references")

		-- Call hierarchy (results go to the location list)
		map("<leader>ci", vim.lsp.buf.incoming_calls, "Incoming calls")
		map("<leader>co", vim.lsp.buf.outgoing_calls, "Outgoing calls")

		-- Rename / change all occurrences
		map("<F2>", ":IncRename " .. "<C-r><C-w>", "Rename symbol")
		map("<C-F2>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]], "Change all occurrences")

		-- Symbols
		map("<leader>o", tb("lsp_document_symbols"), "Symbols in file")
		map("<leader>t", tb("lsp_dynamic_workspace_symbols"), "Symbols in workspace")

		-- Format / refactor
		map("<leader>cf", function() require("conform").format({ async = true }) end, "Format document")
		map("<leader>cF", function()
			local names = vim.tbl_map(function(f) return f.name end, require("conform").list_formatters(ev.buf))
			vim.ui.select(names, { prompt = "Format with:" }, function(choice)
				if choice then require("conform").format({ formatters = { choice } }) end
			end)
		end, "Format with...")
		map("<leader>cr", function() vim.lsp.buf.code_action({ context = { only = { "refactor" } } }) end, "Refactor")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action (create decl/def etc.)", { "n", "v" })

		-- C/C++ extras
		map("<A-o>", function() switch_source_header(ev.buf) end, "Switch header/source")
		map("<leader>cd", "<cmd>Neogen<cr>", "Generate Doxygen comment")
		map("<leader>cR", "<cmd>lsp restart clangd<cr>", "Restart clangd (IntelliSense)")
	end,
})

-- Run Code (like Ctrl+Alt+N): compile and run the current C/C++/Python file
vim.keymap.set("n", "<leader>rr", function()
	vim.cmd("write")
	local ft, f = vim.bo.filetype, vim.fn.expand("%:p")
	local cmds = {
		c = ("gcc -g %s -o /tmp/a.out && /tmp/a.out"):format(f),
		cpp = ("g++ -std=c++20 -g %s -o /tmp/a.out && /tmp/a.out"):format(f),
		python = ("python3 %s"):format(f),
		lua = ("lua %s"):format(f),
	}
	if not cmds[ft] then return vim.notify("No runner for " .. ft) end
	vim.cmd("botright 15split | terminal " .. cmds[ft])
	vim.cmd("startinsert")
end, { desc = "Run code" })
