local this_file        = debug.getinfo(1, "S").source:sub(2)
local this_dir         = vim.fn.fnamemodify(this_file, ":h")
local txt_path         = this_dir .. "/extmarks.txt"
local json_path        = this_dir .. "/extmarks.json"

local txt_f, txt_err   = io.open(txt_path, "w")
local json_f, json_err = io.open(json_path, "w")
if not txt_f then
    error(("Could not open %s: %s"):format(txt_path, txt_err))
end
if not json_f then
    error(("Could not open %s: %s"):format(json_path, json_err))
end

local results = {}
for name, ns_id in pairs(vim.api.nvim_get_namespaces()) do
    local marks = vim.api.nvim_buf_get_extmarks(0, ns_id, 0, -1, { details = true })
    if #marks > 0 then
        -- write to text file
        txt_f:write(("Namespace: %s (%d)\n"):format(name, ns_id))
        txt_f:write(vim.inspect(marks) .. "\n\n")
        -- collect for JSON
        results[name] = {
            namespace_id = ns_id,
            extmarks     = marks,
        }
    end
end

-- JSON-encode and write
-- prefer vim.json if available (for pretty-print), else vim.fn.json_encode
local encoder = vim.json and vim.json.encode or vim.fn.json_encode
local json_text
if vim.json and vim.json.encode then
    json_text = vim.json.encode(results, { indent = true })
else
    json_text = encoder(results)
end

json_f:write(json_text)

txt_f:close()
json_f:close()

print("extmarks saved in misc/extmark-sniffer")
