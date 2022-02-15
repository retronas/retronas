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

function exec_do(cmd_os, options={err:'out'}, dolog=true) {
    cockpit.spawn(cmd_os, options).done(function(data) {
            returned = new String(data);
            //console.log(returned);
            if ( dolog ) { _log(returned); };
            alert("Successful");
            return(true);
        }).fail(function(error){
            returned = new String(error);
            //console.log(error);
            if ( dolog ) { _log(returned); };
            alert("Failed, please check log screen");
            return(false);
        }
    );
}

// privileged exection
function exec_su(cmd_os, dolog=true) {
    var result = exec_do(cmd_os, { 
            err: 'out', 
            superuser: 'require', 
        }, dolog);
    return result;
};

// non-privileged exection
function exec_n(cmd_os, dolog=true) {
    var result = exec_do(cmd_os, { 
        err: 'out', 
    }, dolog);
    return result;
};

// installers
function install_options() {

    var rn_cmd_request = this.id;
    var rn_cmd = '/opt/retronas/lib/ansible_runner.sh';
    var cmd_os = [rn_cmd, rn_cmd_request];

    //console.log(cmd_os)
    var results = exec_su(cmd_os);
};

function run_script() {

    var rn_cmd_request = this.id;
    var rn_cmd = '/opt/retronas/lib/script_runner.sh';
    var cmd_os = [rn_cmd, rn_cmd_request];
    //console.log(cmd_os)
    var results = exec_n(cmd_os);
};

function run_script_values() {

    var rn_cmd_request = this.id;
    var rn_value = document.getElementById(this.id +"-input").value
    this.disabled = true;
    var rn_cmd = '/opt/retronas/lib/script_runner.sh';
    var cmd_os = [rn_cmd, rn_cmd_request, rn_value];
    
    //console.log(cmd_os)
    var results = exec_n(cmd_os, false);
    this.disabled = false;
};

// map basic yaml input to js
function yaml_to_js(yaml) {
    let rn_yaml = [];
    const lines = yaml.split("\n");
    lines.forEach(element => {
        if ( element.length > 0 ) {
            var replaced = element.replaceAll('"',"")
            var split = replaced.split(":");
            //onsole.log(split);

            var key = split[0];
            // clean up the value
            var value = split[1].replace(/^\s+/g, '');

            rn_yaml[key] = value;
        }
    });

    return rn_yaml;
}


// read in the ansible config convert from ansible object to javascript object
// this is used
function read_ansible_cfg() {
    
    cockpit.file('/opt/retronas/ansible/retronas_vars.yml',
        { syntax: "YAML",
          binary: false,
          max_read_size: 256,
          superuser: 'true'
        }).read()
        .then((content, tag) => {
            rn_settings = yaml_to_js(content);
            update_input_from_cfg(rn_settings);
        })
        .catch(error => {
            console.log(error);
            var msg = "Failed to read config file";
            alert(msg);
            _log(msg)
        });

    //promise = file.read()
}

function update_input_from_cfg(rn_settings) {
    document.getElementById('s-set-top-level-dir-input').value = rn_settings['retronas_path'];
    document.getElementById('s-set-etherdfs-nic-input').value = rn_settings['retronas_etherdfs_interface'];

    //document.getElementById('s-set-top-level-dir-input').textContent = rn_settings['retronas_gog_os'];
}

// write a javascript object to ansible format
// this is handled in the called scripts for now
//function write_ansible_cfg() {}


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

    read_ansible_cfg();

}

// nfi what this does, remove it and see what breaks at some point
cockpit.transport.wait(function() { })