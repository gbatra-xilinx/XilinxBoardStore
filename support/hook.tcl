namespace eval ::xhub::board::support {}

proc ::xhub::board::support::install {xitem xstore} {
    set item_name [get_property NAME $xitem]
    set store_name [get_property NAME $xstore]
    puts "$item_name item of $store_name is installed"
    puts "Test call to install proc !"
    setBoardRepoPath $xitem $xstore
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

proc setBoardRepoPath {xitem xstore} {    
    set storeRootDir [get_property USER_REPO_PATH $xstore]
    set boardRepoPath [file join $storeRootDir "boards"]

    if {$boardRepoPath != {}} {
        set projects [get_projects]
        foreach project $projects {
            set project_board_repo_paths [get_property BOARD_PART_REPO_PATHS $project]
            regsub -all $boardRepoPath $project_board_repo_paths "" project_board_repo_paths
            set project_board_repo_paths [string trim $project_board_repo_paths]

            set_property BOARD_PART_REPO_PATHS "$project_board_repo_paths" $project
            set_property BOARD_PART_REPO_PATHS "$project_board_repo_paths $boardRepoPath" $project            
        }
        set current_board_repo_paths [get_param board.repoPaths]
        regsub -all $boardRepoPath $current_board_repo_paths "" current_board_repo_paths        
        set current_board_repo_paths [string trim $current_board_repo_paths]        

        set_param board.repoPaths "$current_board_repo_paths"
        set_param board.repoPaths "$current_board_repo_paths $boardRepoPath"
    }
}
package provide ::xhub::board::support 1.0
