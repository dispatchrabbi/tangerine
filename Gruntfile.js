module.exports = function(grunt) {
	
grunt.initConfig({
	pkg: grunt.file.readJSON('package.json')


});

// List of eventual tasks:
// - deps: install dependencies
// - test: run tests with mocha
// - config: collect information and write the config file
// - db: install the schema in your DB server
// - serve: run the tangerine server
// - backup: download the data from the DB for archiving
// - clean: clean the config file and delete the schema
// - install: essentially, deps + test + config + db
// - cloc: count lines of code, just for fun

};