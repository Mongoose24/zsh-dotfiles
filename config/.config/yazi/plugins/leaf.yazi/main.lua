local M = {}

local function split_lines(s)
	s = tostring(s or ""):gsub("\r\n", "\n")
	if s == "" then
		return { "" }
	end
	if s:sub(-1) ~= "\n" then
		s = s .. "\n"
	end

	local t = {}
	for line in s:gmatch("(.-)\n") do
		t[#t + 1] = line
	end
	return t
end

local function fallback(job, err)
	local code_err, bound = ya.preview_code(job)
	if bound then
		ya.emit("peek", { bound, only_if = job.file.url, upper_bound = true })
	elseif code_err and not code_err:find("cancelled", 1, true) then
		require("empty").msg(job, err or code_err)
	end
end

function M:peek(job)
	local width = math.max(20, job.area.w)
	local output, err = Command("leaf")
		:arg({ "--inline", string.format("ansi:%d", width), tostring(job.file.path) })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not output or not output.status.success then
		return fallback(job, err)
	end

	local lines = split_lines(output.stdout)
	local bound = math.max(0, #lines - job.area.h)
	if job.skip > bound then
		return ya.emit("peek", { bound, only_if = job.file.url, upper_bound = true })
	end

	local visible = {}
	for i = job.skip + 1, math.min(#lines, job.skip + job.area.h) do
		visible[#visible + 1] = lines[i]
	end

	ya.preview_widget(job, ui.Text.parse(table.concat(visible, "\n")):area(job.area):wrap(ui.Wrap.NO))
end

function M:seek(job)
	local h = cx.active.current.hovered
	if not h or h.url ~= job.file.url then
		return
	end

	local step = math.floor(job.units * job.area.h / 10)
	step = step == 0 and ya.clamp(-1, job.units, 1) or step

	ya.emit("peek", {
		math.max(0, cx.active.preview.skip + step),
		only_if = job.file.url,
	})
end

function M:spot(job)
	require("file"):spot(job)
end

return M
