local templet = [[
#!/bin/bash

LOCAL_DIR="%s"

cd ${LOCAL_DIR}
./bits-tool $@
]]

local function gen_script(file, content)

	local f = assert(io.open(file, "w"))
	
	f:write(content)

	f:close()
end

local function chmod(file)
	os.execute(string.format("chmod a+x %s", file))
end

local function main(...)
	local local_dir = arg[1]
	local content = string.format(templet, local_dir);
	local script = string.format("%s/bits.sh", local_dir)

	gen_script(script, content)

	chmod(script)
end

main(...)
