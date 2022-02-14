
function install_options() {

    var rn_cmd_request = this.id;
    var rn_ansible_cmd = '/opt/retronas/lib/ansible_runner.sh';
    var cmd_os = [rn_ansible_cmd, rn_cmd_request];

    console.log(cmd_os)

    cockpit.spawn(cmd_os, { 
        err: 'out', 
        superuser: 'require', 
        directory: '/opt/retronas/ansible'
    }).done(function(data) {
            returned = new String(data);
            console.log(returned);
        }).fail(function(error){
        console.log(error);
        }
    );
};

function run_script() {

    var rn_cmd_request = this.id;
    var rn_ansible_cmd = '/opt/retronas/lib/script_runner.sh';
    var cmd_os = [rn_ansible_cmd, rn_cmd_request];

    console.log(cmd_os)

    cockpit.spawn(cmd_os, { 
        err: 'out', 
        superuser: 'try', 
        directory: '/opt/retronas/scripts'
    }).done(function(data) {
            returned = new String(data);
            console.log(returned);
        }).fail(function(error){
        console.log(error);
        }
    );
};


function show_page() {

    // this is ugly but meh
    const pages = Array.from(document.getElementsByClassName('rn-page-container'));

    pages.forEach(page=>{
        // hide em all first again
        page.classList.replace("rn-show","rn-hidden")
        console.log(page.id);
    })

    // show what we clicked on
    document.getElementById(this.id + "-page").classList.replace("rn-hidden","rn-show")

}

window.onload = function() {

    const installers = Array.from(document.getElementsByClassName('rn-installer'));
    const scripts = Array.from(document.getElementsByClassName('rn-script'));
    const menuitems = Array.from(document.getElementsByClassName('rn-menu-item'));

    installers.forEach(installer=>{
        installer.addEventListener("click", install_options);
    })

    scripts.forEach(script=>{
        script.addEventListener("click", run_script);
    })

    menuitems.forEach(menuitem=>{

        // hide em all first again
        menuitem.addEventListener("click", show_page);

    })

}

cockpit.transport.wait(function() { })