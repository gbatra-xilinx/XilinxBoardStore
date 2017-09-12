namespace eval ::xhub::board::support {}

proc ::xhub::board::support::install {xitem xstore} {
    set item_name [get_property NAME xitem]
    set store_name [get_property NAME xstore]
    puts "$item_name item of $store_name is installed"
    puts "Test call to install proc !"
}

proc ::xhub::board::support::uninstall {xitem xstore} {
    set item_name [get_property NAME xitem]
    set store_name [get_property NAME xstore]
    puts "$item_name item of $store_name is uninstalled"
    puts "Test call to uninstall proc !"
}

package provide ::xhub::board::support 1.0