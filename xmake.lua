set_project("binoutshow")

add_requires("dynareadout")

add_rules("mode.debug", "mode.release")
target("binoutshow")
	set_kind("binary")
	set_languages("ansi")
	add_packages("dynareadout")
	if is_plat("linux") then
		add_cflags("-fPIC")
	end
	add_files("*.c")
