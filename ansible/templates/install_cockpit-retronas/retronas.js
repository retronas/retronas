//                            __________________________
//         .-:=[ RetroNAS_Cockpit_Package ]=:-.
//
// This file supports the Cockpit integration for RetroNAS
//
// Read the comments throughout this file for more information
//

// update log window
function _log(output) {
    document.getElementById("log-area").innerText = output;
}

// privileged exection
function exec_su(cmd_os, dolog=true) {

    cockpit.spawn(cmd_os, { 
        err: 'out', 
        superuser: 'require', 
    }).done(function(data) {
            returned = new String(data);
            //console.log(returned);
            if ( dolog ) { _log(returned); };
            alert("Successful");
        }).fail(function(error){
            returned = new String(error);
            //console.log(error);
            alert("Failed, please check log screen");
            if ( dolog ) { _log(returned); };
        }
    );
};

// non-privileged exection
function exec_n(cmd_os, dolog=true) {

    cockpit.spawn(cmd_os, { 
        err: 'out',  
    }).done(function(data) {
            returned = new String(data);
            //console.log(returned);
            if ( dolog ) { _log(returned); };
            alert("Successful");
        }).fail(function(error){
            returned = new String(error);
            //console.log(error);
            alert("Failed, please check log screen");
            if ( dolog ) { _log(returned); };
        }
    );
};

// installers
function install_options() {

    var rn_cmd_request = this.id;
    //this.disabled = true;
    var rn_cmd = '/opt/retronas/lib/ansible_runner.sh';
    var cmd_os = [rn_cmd, rn_cmd_request];

    //console.log(cmd_os)
    var results = exec_su(cmd_os);
};

function run_script() {

    var rn_cmd_request = this.id;
    //this.disabled = true;
    var rn_cmd = '/opt/retronas/lib/script_runner.sh';
    var cmd_os = [rn_cmd, rn_cmd_request];
    //console.log(cmd_os)
    var results = exec_n(cmd_os);
};

function run_script_values() {

    var rn_cmd_request = this.id;
    var rn_value = document.getElementById(this.id +"-input").value
    //this.disabled = true;
    var rn_cmd = '/opt/retronas/lib/script_runner.sh';
    var cmd_os = [rn_cmd, rn_cmd_request, rn_value];
    
    //console.log(cmd_os)
    var results = exec_n(cmd_os, false);
};


// read in the ansible config from ansible object to javascript object
// this is used
function read_ansible_cfg() {}

// write a javascript object to ansible format
function write_ansible_cfg() {}


// scan a path returning output to a listing of some kind
function scan_path() {

    var rn_cmd_request = this.id;
    this.disabled = true;
    var rn_cmd = '/opt/retronas/lib/format_path.sh';
    var cmd_os = [rn_cmd, rn_cmd_request];

    console.log(cmd_os)
    var results = exec_n(cmd_os);
};

// page switcher, now you see it, now you don't
function show_page() {

    // this is ugly but meh
    const pages = Array.from(document.getElementsByClassName('rn-page-container'));

    pages.forEach(page=>{
        // hide em all first again
        page.classList.replace("rn-show","rn-hidden")
    })

    // show what we clicked on
    document.getElementById(this.id + "-page").classList.replace("rn-hidden","rn-show")

}

// waiting until we're loaded up so the elements we need are available
window.onload = function() {

    // group the elements we require to work with
    // we do this by class because it was easier
    const installers = Array.from(document.getElementsByClassName('rn-installer'));
    const scripts = Array.from(document.getElementsByClassName('rn-script'));
    const menuitems = Array.from(document.getElementsByClassName('rn-menu-item'));
    const updaters = Array.from(document.getElementsByClassName('rn-value-updater'));

    // installers (rn-installer)
    installers.forEach(installer=>{
        installer.addEventListener("click", install_options);
    })

    // scripts (rn-script)
    scripts.forEach(script=>{
        script.addEventListener("click", run_script);
    })

    // menu items (rn-menu-item)
    menuitems.forEach(menuitem=>{
        menuitem.addEventListener("click", show_page);
    })

    // updaters (rn-value updaters)
    updaters.forEach(updater=>{
        updater.addEventListener("click", run_script_values);
    })


}

// nfi what this does, remove it and see what breaks at some point
cockpit.transport.wait(function() { })