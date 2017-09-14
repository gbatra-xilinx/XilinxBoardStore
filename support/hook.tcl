namespace eval ::xhub::board::support {}

proc ::xhub::board::support::install {xitem xstore} {
    set item_name [get_property NAME $xitem]
    set store_name [get_property NAME $xstore]
    puts "$item_name item of $store_name is installed"
    puts "Test call to install proc !"
}

proc ::xhub::board::support::uninstall {xitem xstore} {
    set item_name [get_property NAME $xitem]
    set store_name [get_property NAME $xstore]
    puts "$item_name item of $store_name is uninstalled"
    puts "Test call to uninstall proc !"
}

proc ::xhub::board::support::init {xstore} {
    set name [get_property NAME $xstore]
    puts "$name store is being initialized"
    set storeRootDir [get_property USER_REPO_PATH $xstore]
    set boardRepoPath [file join $storeRootDir "boards"]
    set current_board_repo_paths [get_param board.repoPaths]
    set_param board.repoPaths "$current_board_repo_paths $boardRepoPath"
}

proc ::xhub::board::support::uninit {xstore} {
    set name [get_property NAME $xstore]
    puts "$name store is being uninitialized"
}

package provide ::xhub::board::support 1.0
