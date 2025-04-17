--- @since 25.4.4
local M = {}
local PackageName = "save-clipboard-to-file"

local function fail(s, ...)
	ya.notify({ title = PackageName, content = string.format(s, ...), timeout = 3, level = "error" })
end

local function warn(s, ...)
	ya.notify({ title = PackageName, content = string.format(s, ...), timeout = 3, level = "warn" })
end

local function pathJoin(...)
	-- Detect OS path separator ('\' for Windows, '/' for Unix)
	local separator = package.config:sub(1, 1)
	local parts = { ... }
	local filteredParts = {}
	-- Remove empty strings or nil values
	for _, part in ipairs(parts) do
		if part and part ~= "" then
			table.insert(filteredParts, part)
		end
	end
	-- Join the remaining parts with the separator
	local path = table.concat(filteredParts, separator)
	-- Normalize any double separators (e.g., "folder//file" → "folder/file")
	path = path:gsub(separator .. "+", separator)

	return path
end

local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function input_file_name()
	local input_value, input_event = ya.input({
		title = "Enter file name:",
		position = { "center", w = 100 },
	})
	if input_event == 1 then
		if not input_value then
			warn("File name can't be empty!")
			return
		elseif input_value:match("/$") then
			warn("File name can't ends with '/'")
			return
		end
		return input_value
	end
end

function M:entry(job)
	-- Get contents from the clipboard
	local clipboard_content = ya.clipboard()
	if not clipboard_content then
		warn("Clipboard is empty!")
		return
	end
	local file_name = input_file_name()
	if not file_name then
		return
	end
	local file_path = Url(pathJoin(get_cwd(), file_name))
	local cha, _ = fs.cha(file_path)
	if cha then
		local overwrite_confirmed = ya.confirm({
			title = ui.Line("Save clipboard to file"):style(th and th.confirm and th.confirm.title),
			content = ui.Text({
				ui.Line(""),
				ui.Line("The following file is existed, overwrite?"):style(ui.Style():fg("yellow")),
				ui.Line(""),
				ui.Line({
					ui.Span(" "),
					ui.Span(tostring(file_path)):style(th and th.confirm and th.confirm.list or ui.Style():fg("blue")),
				}):align(ui.Line.LEFT),
			})
				:align(ui.Text.LEFT)
				:wrap(ui.Text.WRAP),
			pos = { "center", w = 100, h = 10 },
		})
		if overwrite_confirmed then
			local deleted_collided_item, _ = fs.remove("file", file_path)
			if not deleted_collided_item then
				warn("Failed to delete collided file: %s", tostring(file_path))
				return
			end
			if file_path.parent then
				fs.create("dir_all", file_path.parent)
			end
			fs.write(file_path, clipboard_content)
		end
	else
		if file_path.parent then
			fs.create("dir_all", file_path.parent)
		end
		fs.write(file_path, clipboard_content)
	end
end
return M
