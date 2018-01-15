namespace eval ::xhub::board::support {}

proc ::xhub::board::support::install {xitem xstore} {
    set item_name [get_property NAME $xitem]
    set store_name [get_property NAME $xstore]
    puts "$item_name item of $store_name is installed"
    puts "Test call to install proc !"
    setBoardRepoPath $xitem $xstore
}

proc ::xhub::board::support::canUninstall {xitem xstore} {
    set board_name [getBoard $xitem]
    set current_projects [get_projects]

    foreach project $current_projects {
        set project_name [get_property NAME $project]
        set board_part [get_property BOARD_PART $project]

        if { $board_part != {}} {
            set project_board_name [get_property NAME [get_boards -of_objects [get_board_parts $board_part]]]
            if {$project_board_name eq $board_name} {
                return "Can't uninstall board '$board_name' as it is currently being used by project '$project_name'.\nClose project '$project_name' and try again"
            }
        }
    }
    return ""
}

proc ::xhub::board::support::uninstall {xitem xstore} {
    set item_name [get_property NAME $xitem]
    set store_name [get_property NAME $xstore]
    puts "$item_name item of $store_name is uninstalled"
    puts "Test call to uninstall proc !"
    setBoardRepoPath $xitem $xstore
}

proc ::xhub::board::support::init {xstore} {
    set name [get_property NAME $xstore]
    puts "$name store is being initialized"
    set storeRootDir [get_property LOCAL_ROOT_DIR $xstore]
    set boardRepoPath [file join $storeRootDir "boards"]
    set current_board_repo_paths [get_param board.repoPaths]
    set_param board.repoPaths "$current_board_repo_paths $boardRepoPath"
}

proc ::xhub::board::support::uninit {xstore} {
    set name [get_property NAME $xstore]
    puts "$name store is being uninitialized"
}

proc ::xhub::board::support::setBoardRepoPath {xitem xstore} {    
    set storeRootDir [get_property LOCAL_ROOT_DIR $xstore]
    set xitemRootDir [get_property XITEM_ROOT $xstore]
    if {$xitemRootDir != {}} {
        set boardRepoPath [file join $storeRootDir $xitemRootDir]
    } else {
        set boardRepoPath "$storeRootDir"
    }  
    
    if {$boardRepoPath != {}} {
        set projects [get_projects -quiet]
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

proc ::xhub::board::support::getBoard {xitem} {
    set name [get_property SHORT_NAME $xitem]
    set company [get_property COMPANY $xitem]
    set revision [get_property REVISION $xitem]

    set board_name "$company\:$name\:$revision"
    return $board_name
}

package provide ::xhub::board::support 1.0
