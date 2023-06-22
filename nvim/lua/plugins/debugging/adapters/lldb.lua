local codelldb_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/codelldb"

-- codelldb uses TCP for the DAP communication - so we use the server type for the adapter definition.
require("dap").adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb_path,
		args = { "--port", "${port}" },

		-- On windows you may have to uncomment this:
		-- detached = false,
	},
}
